-- LOCAL VARIABLES <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local callback = client.set_event_callback
local combo = ui.new_combobox
local circle = renderer.circle
local getui = ui.get
local slider = ui.new_slider
local text = renderer.text
local checkbox = ui.new_checkbox
local getprop = entity.get_prop
local color = ui.new_color_picker
local gradient = renderer.gradient
local vis = ui.set_visible
local setui = ui.set
local rect = renderer.rectangle
local getall = entity.get_all
local visible = ui.set_visible
local indicator = renderer.indicator
local triangle = renderer.triangle

local w, h = client.screen_size()

-- MENU ITEMS <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local style = combo("Lua", "B", "Netvar style", "-", "Circle", "Circle outline", "Boxes", "Vertical boxes", "Text", "Indicator", "Bars", "Skeet")
local colstyle = combo("Lua", "B", "Color style", "Default", "Custom")
local colstyleG = combo("Lua", "B", "Color style", "Default", "Custom", "Gradient", "Custom gradient")

local resize = checkbox("Lua", "B", "Resize")
local circleresizeslider = slider("Lua", "B", "Size", 0, 100, 36, true)
local circlethiccslider = slider("Lua", "B", "Thiccness", 0, 100, 13, true)
local lengthslider = slider("Lua", "B", "Length", 0, 1000, 150, true)
local widthslider = slider("Lua", "B", "Width", 0, 1000, 26, true)
local reposition = checkbox("Lua", "B", "Reposition")
local numcheck = checkbox("Lua", "B", "Display numbers")

local pingcheck = checkbox("Lua", "B", "Ping")
local pc = color("Lua", "B", "Ping col", 255, 255, 255, 255)
local px = slider("Lua", "B", "Ping X", 0, w, w / 2, true)
local py = slider("Lua", "B", "Ping Y", 0, h, h / 2, true)

local latencycheck = checkbox("Lua", "B", "Latency")
local lc = color("Lua", "B", "Latency col", 255, 255, 255, 255)
local lx = slider("Lua", "B", "Latency X", 0, w, w / 2, true)
local ly = slider("Lua", "B", "Latency Y", 0, h, h / 2, true)

local fakelagcheck = checkbox("Lua", "B", "Choked packets")
local cc = color("Lua", "B", "Choke col", 255, 255, 255, 255)
local flx = slider("Lua", "B", "Choked packets X", 0, w, w / 2, true)
local fly = slider("Lua", "B", "Choked packets Y", 0, h, h / 2, true)

local speedcheck = checkbox("Lua", "B", "Speed")
local sc = color("Lua", "B", "Speed col", 255, 255, 255, 255)
local sx = slider("Lua", "B", "Speed X", 0, w, w / 2, true)
local sy = slider("Lua", "B", "Speed Y", 0, h, h / 2, true)

local fpscheck = checkbox("Lua", "B", "Fps")
local fc = color("Lua", "B", "Fps col", 255, 255, 255, 255)
local fx = slider("Lua", "B", "Fps X", 0, w, w / 2, true)
local fy = slider("Lua", "B", "Fps Y", 0, h, h / 2, true)

local x = slider("Lua", "B", "X", 0, w, w / 2 - 80, true)
local y = slider("Lua", "B", "Y", 0, h, h / 2 - 41, true)

--ROUNDING FUNCTION--
local function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)

	if num >= 0 then return math.floor(num * mult + 0.5) / mult
	else 
		return math.ceil(num * mult - 0.5) / mult
	end
end

local function on_run_command(c)
	--GET CHOCKED PACKETS--
	local localPlayer = entity.get_local_player()
	if localPlayer ~= nil then
		choke = c.chokedcommands
	end

	--VISIBILITY <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

	if getui(style) == "-" then
		vis(colstyle, false)
		vis(colstyleG, false)
		setui(reposition, false)
		vis(resize, false)
		setui(resize, false)
		vis(numcheck, false)
		vis(reposition, false)
		vis(pingcheck, false)
		vis(pc, false)
		vis(latencycheck, false)
		vis(lc, false)
		vis(fakelagcheck, false)
		vis(cc, false)
		vis(speedcheck, false)
		vis(sc, false)
		vis(fpscheck, false)
		vis(fc, false)
	else
		if getui(style) == "Boxes" or getui(style) == "Vertical boxes" or getui(style) == "Bars" or getui(style) == "Skeet" then
			if getui(colstyleG) == "Custom" then
				vis(pc, true)
				vis(lc, true)
				vis(cc, true)
				vis(sc, true)
				vis(fc, true)
			else
				vis(pc, false)
				vis(lc, false)
				vis(cc, false)
				vis(sc, false)
				vis(fc, false)
			end
			vis(colstyleG, true)
			vis(colstyle, false)
		else
			if getui(colstyle) == "Custom" then
				vis(pc, true)
				vis(lc, true)
				vis(cc, true)
				vis(sc, true)
				vis(fc, true)
			else
				vis(pc, false)
				vis(lc, false)
				vis(cc, false)
				vis(sc, false)
				vis(fc, false)
			end
			vis(colstyleG, false)
			vis(colstyle, true)
		end

		if getui(style) == "Text" then
			vis(numcheck, false)
		else
			vis(numcheck, true)
		end

		if getui(style) == "Bars" or getui(style) == "Skeet" then
			if getui(colstyleG) ~= "Custom" then
				vis(pingcheck, false)
				vis(latencycheck, false)
				vis(fakelagcheck, false)
				vis(speedcheck, false)
				vis(fpscheck, false)
			else
				vis(pingcheck, true)
				vis(latencycheck, true)
				vis(fakelagcheck, true)
				vis(speedcheck, true)
				vis(fpscheck, true)
			end
		else
			vis(pingcheck, true)
			vis(latencycheck, true)
			vis(fakelagcheck, true)
			vis(speedcheck, true)
			vis(fpscheck, true)
		end

		if getui(style) == "Circle outline" then
			vis(resize, true)
		else
			setui(resize, false)
			vis(resize, false)
		end
		
		vis(reposition, true)
	end

	if getui(reposition, true) then
		if getui(style) == "Bars" or getui(style) == "Skeet" then
			vis(px, false)
			vis(py, false)
			vis(lx, false)
			vis(ly, false)
			vis(flx, false)
			vis(fly, false)
			vis(sx, false)
			vis(sy, false)
			vis(fx, false)
			vis(fy, false)
			vis(x, true)
			vis(y, true)
		else
			vis(x, false)
			vis(y, false)

			if getui(pingcheck, true) then
				vis(px, true)
				vis(py, true)
			else
				vis(px, false)
				vis(py, false)
			end

			if getui(latencycheck, true) then
				vis(lx, true)
				vis(ly, true)
			else
				vis(lx, false)
				vis(ly, false)
			end

			if getui(fakelagcheck, true) then
				vis(flx, true)
				vis(fly, true)
			else
				vis(flx, false)
				vis(fly, false)
			end

			if getui(speedcheck, true) then
				vis(sx, true)
				vis(sy, true)
			else
				vis(sx, false)
				vis(sy, false)
			end

			if getui(fpscheck, true) then
				vis(fx, true)
				vis(fy, true)
			else
				vis(fx, false)
				vis(fy, false)
			end
		end
	else
		vis(px, false)
		vis(py, false)
		vis(lx, false)
		vis(ly, false)
		vis(flx, false)
		vis(fly, false)
		vis(sx, false)
		vis(sy, false)
		vis(fx, false)
		vis(fy, false)
		vis(x, false)
		vis(y, false)
	end

	if getui(resize, true) then
		if getui(style) == "Circle outline" then
			vis(circleresizeslider, true)
			vis(circlethiccslider, true)
			vis(lengthslider, false)
			vis(widthslider, false)
		end
	else
		vis(lengthslider, false)
		vis(widthslider, false)
		vis(circleresizeslider, false)
		vis(circlethiccslider, false)
	end
end

callback('run_command', on_run_command)

--GET PLAYER INFO--
local function get_info()
	local localPlayer = entity.get_local_player()
	if localPlayer ~= nil then
		--ping--
		local playerResource = getall("CCSPlayerResource")[1]
		ping = getprop(playerResource, "m_iPing", localPlayer)
		--latency--
		latency = client.latency()
		delay = math.floor(latency * 1000)
	    --speed--
		local vx, vy = getprop(localPlayer, "m_vecVelocity")
		if vx ~= nil then
			local vel1 = math.sqrt(vx * vx + vy * vy)
			vel2 = math.min(9999, vel1) + 0.2
			velocity = round(vel2, 0)
		end
	end
end

callback('paint', get_info)

--GET FPS--
local g_frameRate = 0.0
local function fps()
    g_frameRate = 0.9 * g_frameRate + (1.0 - 0.9) * globals.absoluteframetime()
    return math.floor((1.0 / g_frameRate) + 0.5)
end

-- COLORS <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local function Colors()
	--default and custom only--
	if getui(colstyle) == "Default" then
		if ping > 255 then
			prc = 255
			pgc = 0
		else
			prc = ping
			pgc = -ping
		end

		if delay > 255 then
			lrc = 255
			lgc = 0
		else
			if delay ~= 0 then
				lrc = delay
				lgc = -delay
			else
				lrc = 0
				lgc = 255
			end
		end

		local choked = choke * 18.21428571428571
		if choked > 255 then
			crc = 0
			cgc = 255
		else
			if choke ~= 0 then
				crc = -choked
				cgc = choked
			else
				crc = 255
				cgc = 0
			end
		end

		if velocity > 255 then
			src = 0
			sgc = 255
		else
			if velocity ~= 0 then
				src = -velocity
				sgc = velocity
			else
				src = 255
				sgc = 0
			end
		end

		local x = fps()
		local fps = x * 1.770833333333333
		local col = round(x, 0)
		if fps > 255 then
			frc = 0
			fgc = 255
		else
			frc = -col
			fgc = col
		end

		pr, pg, pb, pa = prc, pgc, 0, 255
		lr, lg, lb, la = lrc, lgc, 0, 255
		cr, cg, cb, ca = crc, cgc, 0, 255
		sr, sg, sb, sa = src, sgc, 0, 255
		fr, fg, fb, fa = frc, fgc, 0, 255
	elseif getui(colstyle) == "Custom" then
		pr, pg, pb, pa = getui(pc)
		lr, lg, lb, la = getui(lc)
		cr, cg, cb, ca = getui(cc)
		sr, sg, sb, sa = getui(sc)
		fr, fg, fb, fa = getui(fc)
	end
	--includes gradients--
	if getui(colstyleG) == "Default" then
		if ping > 255 then
			prcg = 255
			pgcg = 0
		else
			prcg = ping
			pgcg = -ping
		end

		if delay > 255 then
			lrcg = 255
			lgcg = 0
		else
			lrcg = delay
			lgcg = -delay
		end

		local choked = choke * 18.21428571428571
		if choked > 255 then
			crcg = 0
			cgcg = 255
		else
			if choke ~= 0 then
				crcg = -choked
				cgcg = choked
			else
				crcg = 255
				cgcg = 0
			end
		end

		if velocity > 255 then
			srcg = 0
			sgcg = 255
		else
			if velocity ~= 0 then
				srcg = -velocity
				sgcg = velocity
			else
				srcg = 255
				sgcg = 0
			end
		end

		local x = fps()
		local fps = x * 1.770833333333333
		if fps > 255 then
			frcg = 0
			fgcg = 255
		else
			frcg = -x
			fgcg = x
		end

		prg, pgg, pbg, pag = prcg, pgcg, 0, 255
		lrg, lgg, lbg, lag = lrcg, lgcg, 0, 255
		crg, cgg, cbg, cag = crcg, cgcg, 0, 255
		srg, sgg, sbg, sag = srcg, sgcg, 0, 255
		frg, fgg, fbg, fag = frcg, fgcg, 0, 255
	elseif getui(colstyleG) == "Custom" then
		prg, pgg, pbg, pag = getui(pc)
		lrg, lgg, lbg, lag = getui(lc)
		crg, cgg, cbg, cag = getui(cc)
		srg, sgg, sbg, sag = getui(sc)
		frg, fgg, fbg, fag = getui(fc)
	end
end

callback('paint', Colors)

-- CIRCLE <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local function Circle(ctx)
	if getui(style) == "Circle" then
		if getui(pingcheck, true) then
			local x = getui(px)
			local y = getui(py)

			--[[if getui(resize, true) then
		    	radius = getui(circleresizeslider)
		    else		    			    			    	[FOR RESIZABILITY]
		    	radius = 1
		    end]]

			if ping / 8 <= 25 then
				circle(x, y, pr, pg, pb, pa, ping / 8, 0, 1)
			else
				circle(x, y, pr, pg, pb, pa, 25, 0, 1)
			end

			if getui(numcheck, true) then
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Ping: ".. ping)
			else
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Ping")
			end
		end

		if getui(latencycheck, true) then
			local x = getui(lx)
			local y = getui(ly)
			if delay == 0 then
				circle(x, y, lr, lg, lb, la, 0, 0, 1)
			elseif delay <= 150 then
				circle(x, y, lr, lg, lb, la, delay / 6, 0, 1)
			elseif delay > 150 then
				circle(x, y, lr, lg, lb, la, 25, 0, 1)
			end

			if getui(numcheck, true) then
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Latency: ".. latency)
			else
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Latency")
			end
		end

		if getui(fakelagcheck, true) then
			local x = getui(flx)
			local y = getui(fly)
			circle(x, y, cr, cg, cb, ca, choke * 1.785714285714286, 0, 1)

			if getui(numcheck, true) then
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Choke: ".. choke)
			else
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Choke")
			end
		end

		if getui(speedcheck, true) then
			local x = getui(sx)
			local y = getui(sy)
			if velocity ~= nil and velocity <= 250 then
				circle(x, y, sr, sg, sb, sa, velocity / 10, 0, 1)
			elseif velocity > 250 then
				circle(x, y, sr, sg, sb, sa, 25, 0, 1)
			end

			if getui(numcheck, true) then
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Speed: ".. velocity)
			else
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Speed")
			end
		end

		if getui(fpscheck, true) then
			local x = getui(fx)
			local y = getui(fy)
			if fps() > 143 then
				circle(x, y, fr, fg, fb, fa, 25, 0, 1)
			else
				circle(x, y, fr, fg, fb, fa, fps() * 0.18, 0, 1)
			end

			if getui(numcheck, true) then
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Fps: ".. fps())
			else
				text(x, y - 40, 255, 255, 255, 255, "cb", 0, "Fps")
			end
		end
	end
end

callback('paint', Circle)

-- CIRCLE OUTLINE <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local function draw_indicator_circle(ctx, x, y, r, g, b, a, percentage, outline)
    local outline = outline == nil and true or outline
    local start_degrees = 0

    if getui(resize, true) then
    	radius = getui(circleresizeslider)
    	thiccness = getui(circlethiccslider)
    else
    	radius = 36
    	thiccness = 13
    end

    if outline then
        client.draw_circle_outline(ctx, x, y, 0, 0, 0, 200, radius, start_degrees, 1.0, thiccness)
    end

    client.draw_circle_outline(ctx, x, y, r, g, b, a, radius - 1, start_degrees, percentage, thiccness - 2)
end

local function Circle_outline(ctx)
	if getui(style) == "Circle outline" then
		if getui(pingcheck, true) then
			local x = getui(px)
			local y = getui(py)
			
			draw_indicator_circle(ctx, x, y, pr, pg, pb, pa, ping / 150, outline)

			if getui(numcheck, true) then
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Ping: ".. ping)
			else
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Ping")
			end
		end

		if getui(latencycheck, true) then
			local x = getui(lx)
			local y = getui(ly)

			draw_indicator_circle(ctx, x, y, lr, lg, lb, 255, latency * 6.666666666666667, outline)

			if getui(numcheck, true) then
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Latency: ".. latency)
			else
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Latency")
			end
		end

		if getui(fakelagcheck, true) then
			local x = getui(flx)
			local y = getui(fly)

			draw_indicator_circle(ctx, x, y, cr, cg, cb, ca, choke * 10.71428571428571 / 150, outline)

			if getui(numcheck, true) then
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Choke: ".. choke)
			else
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Choke")
			end
		end

		if getui(speedcheck, true) then
			local x = getui(sx)
			local y = getui(sy)

			draw_indicator_circle(ctx, x, y, sr, sg, sb, sa, velocity / 300, outline)

			if getui(numcheck, true) then
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Speed: ".. velocity)
			else
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Speed")
			end
		end

		if getui(fpscheck, true) then
			local x = getui(fx)
			local y = getui(fy)

			draw_indicator_circle(ctx, x, y, fr, fg, fb, fa, fps() / 250, outline)

			if getui(numcheck, true) then
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Fps: ".. fps())
			else
				text(x, y - radius - 15, 255, 255, 255, 255, "cb", 0, "Fps")
			end
		end
	end
end

callback('paint', Circle_outline)

-- BOXES <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local function Boxes(ctx)
	if getui(style) == "Boxes" then
		if getui(pingcheck, true) then
			local x = getui(px)
			local y = getui(py)

			rect(x - 78, y - 16, 156, 32, 0, 0, 0, 200)

			if ping <= 150 then
				rect(x - 75, y - 13, ping, 26, prg, pgg, pbg, pag)
			else
				rect(x - 75, y - 13, 150, 26, prg, pgg, pbg, pag)
			end

			if getui(numcheck, true) then
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Ping: ".. ping)
			else
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Ping")
			end
		end

		if getui(latencycheck, true) then
			local x = getui(lx)
			local y = getui(ly)

			rect(x - 78, y - 16, 156, 32, 0, 0, 0, 200)

			if delay <= 150 then
				rect(x - 75, y - 13, latency, 26, lrg, lgg, lbg, lag)
			else
				rect(x - 75, y - 13, 150, 26, lrg, lgg, lbg, lag)
			end

			if getui(numcheck, true) then
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Latency: ".. latency)
			else
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Latency")
			end
		end

		if getui(fakelagcheck, true) then
			local x = getui(flx)
			local y = getui(fly)
			
			rect(x - 78, y - 16, 156, 32, 0, 0, 0, 200)

			rect(x - 75, y - 13, choke * 10.71428571428571, 26, crg, cgg, cbg, cag)

			if getui(numcheck, true) then
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Choke: ".. choke)
			else
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Choke")
			end
		end

		if getui(speedcheck, true) then
			local x = getui(sx)
			local y = getui(sy)

			rect(x - 78, y - 16, 156, 32, 0, 0, 0, 200)

			if velocity <= 300 then
				rect(x - 75, y - 13, velocity / 2, 26, srg, sgg, sbg, sag)
			else
				rect(x - 75, y - 13, 150, 26, srg, sgg, sbg, sag)
			end

			if getui(numcheck, true) then
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Speed: ".. velocity)
			else
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Speed")
			end
		end

		if getui(fpscheck, true) then
			local x = getui(fx)
			local y = getui(fy)

			rect(x - 78, y - 16, 156, 32, 0, 0, 0, 200)

			if fps() <= 150 then
				rect(x - 75, y - 13, fps(), 26, frg, fgg, fbg, fag)
			else
				rect(x - 75, y - 13, 150, 26, frg, fgg, fbg, fag)
			end

			if getui(numcheck, true) then
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Fps: ".. fps())
			else
				text(x, y - 30, 255, 255, 255, 255, "cb", 0, "Fps")
			end
		end
	end
end

callback('paint', Boxes)

-- VERTICAL BOXES <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local function VerticalBoxes(ctx)
	if getui(style) == "Vertical boxes" then
		if getui(pingcheck, true) then
			local x = getui(px)
			local y = getui(py)

			rect(x - 16, y - 78, 32, 156, 0, 0, 0, 200)

			if ping <= 150 then
				rect(x - 13, y - 75, 26, ping, prg, pgg, pbg, pag)
			else
				rect(x - 13, y - 75, 26, 150, prg, pgg, pbg, pag)
			end

			if getui(numcheck, true) then
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Ping: ".. ping)
			else
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Ping")
			end
		end

		if getui(latencycheck, true) then
			local x = getui(lx)
			local y = getui(ly)

			rect(x - 16, y - 78, 32, 156, 0, 0, 0, 200)

			if delay <= 150 then
				rect(x - 13, y - 75, 26, latency, lrg, lgg, lbg, lag)
			else
				rect(x - 13, y - 75, 26, 150, lrg, lgg, lbg, lag)
			end

			if getui(numcheck, true) then
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Latency: ".. latency)
			else
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Latency")
			end
		end

		if getui(fakelagcheck, true) then
			local x = getui(flx)
			local y = getui(fly)
			
			rect(x - 16, y - 78, 32, 156, 0, 0, 0, 200)

			rect(x - 13, y - 75, 26, choke * 10.71428571428571, crg, cgg, cbg, cag)

			if getui(numcheck, true) then
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Choke: ".. choke)
			else
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Choke")
			end
		end

		if getui(speedcheck, true) then
			local x = getui(sx)
			local y = getui(sy)

			rect(x - 16, y - 78, 32, 156, 0, 0, 0, 200)

			if velocity <= 300 then
				rect(x - 13, y - 75, 26, velocity / 2, srg, sgg, sbg, sag)
			else
				rect(x - 13, y - 75, 26, 150, srg, sgg, sbg, sag)
			end

			if getui(numcheck, true) then
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Speed: ".. velocity)
			else
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Speed")
			end
		end

		if getui(fpscheck, true) then
			local x = getui(fx)
			local y = getui(fy)

			rect(x - 16, y - 78, 32, 156, 0, 0, 0, 200)

			if fps() <= 150 then
				rect(x - 13, y - 75, 26, fps(), frg, fgg, fbg, fag)
			else
				rect(x - 13, y - 75, 26, 150, frg, fgg, fbg, fag)
			end

			if getui(numcheck, true) then
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Fps: ".. fps())
			else
				text(x, y - 88, 255, 255, 255, 255, "cb", 0, "Fps")
			end
		end
	end
end

callback('paint', VerticalBoxes)

-- TEXT <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local function Text(ctx)
	if getui(style) == "Text" then
		if getui(pingcheck, true) then
			local x = getui(px)
			local y = getui(py)

			text(x - 13, y, 255, 255, 255, 255, "c", 0, "Ping:")
			text(x + 13, y, pr, pg, pb, pa, "c", 0, ping)
		end

		if getui(latencycheck, true) then
			local x = getui(lx)
			local y = getui(ly)

			text(x - 17, y, 255, 255, 255, 255, "c", 0, "Latency:")
			text(x + 18, y, lr, lg, lb, la, "c", 0, round(latency, 0))
		end

		if getui(fakelagcheck, true) then
			local x = getui(flx)
			local y = getui(fly)
			
			text(x - 15, y, 255, 255, 255, 255, "c", 0, "Choke:")
			text(x + 16, y, cr, cg, cb, ca, "c", 0, choke)
		end

		if getui(speedcheck, true) then
			local x = getui(sx)
			local y = getui(sy)

			text(x - 15, y, 255, 255, 255, 255, "c", 0, "Speed:")
			text(x + 16, y, sr, sg, sb, sa, "c", 0, velocity)
		end

		if getui(fpscheck, true) then
			local x = getui(fx)
			local y = getui(fy)

			text(x - 12, y, 255, 255, 255, 255, "c", 0, "Fps:")
			text(x + 12, y, fr, fg, fb, fa, "c", 0, fps())
		end
	end
end

callback('paint', Text)

-- INDICATOR <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local function Indicator(ctx)
	if getui(style) == "Indicator" then
		indicator(255, 255, 255, 255, "Hello")
		local x = fps()
		if getui(fpscheck, true) then
			indicator(fr, fg, fb, fa, "Fps: ".. x)
		end

		if getui(speedcheck, true) then
			indicator(sr, sg, sb, sa, "Speed: ".. velocity)
		end	

		if getui(fakelagcheck, true) then
			indicator(cr, cg, cb, ca, "Choke: ".. choke)
		end

		if getui(latencycheck, true) then
			indicator(lr, lg, lb, la, "Delay: ".. round(latency, 0))
		end

		if getui(pingcheck, true) then
			indicator(pr, pg, pb, pa, "Ping: ".. ping)
		end	
	end
end

callback('paint', Indicator)

-- BARS <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local function Bars(ctx)
	if getui(style) == "Bars" then
		rect(getui(x), getui(y), 160, 82, 35, 35, 35, 220)

		--ping--
		text(getui(x) + 5, getui(y) + 5, 255, 255, 255, 255, "", 0, "Ping")
		rect(getui(x) + 51, getui(y) + 8, 99.5, 7, 0, 0, 0, 255)
		if ping * 0.65 <= 97.5 then
			rect(getui(x) + 52, getui(y) + 9, ping * 0.65, 5, prg, pgg, pbg, pag)
			pd = ping * 0.65
		else
			rect(getui(x) + 52, getui(y) + 9, 97.5, 5, prg, pgg, pbg, pag)
			pd = 97.5
		end

		--latency--
		text(getui(x) + 5, getui(y) + 20, 255, 255, 255, 255, "", 0, "Delay")
		rect(getui(x) + 51, getui(y) + 23, 99.5, 7, 0, 0, 0, 255)
		if delay <= 97.5 then
			rect(getui(x) + 52, getui(y) + 24, delay, 5, lrg, lgg, lbg, lag)
			ld = delay
		else
			rect(getui(x) + 52, getui(y) + 24, 97.5, 5, lrg, lgg, lbg, lag)
			ld = 97.5
		end

		--choke--
		text(getui(x) + 5, getui(y) + 35, 255, 255, 255, 255, "", 0, "Choke")
		rect(getui(x) + 51, getui(y) + 38, 99.5, 7, 0, 0, 0, 255)
		rect(getui(x) + 52, getui(y) + 39, choke * 6.964285714285714, 5, crg, cgg, cbg, cag)

		--speed--
		text(getui(x) + 5, getui(y) + 50, 255, 255, 255, 255, "", 0, "Speed")
		rect(getui(x) + 51, getui(y) + 53, 99.5, 7, 0, 0, 0, 255)
		if velocity * 0.3 <= 97.5 then
			rect(getui(x) + 52, getui(y) + 54, velocity * 0.3, 5, srg, sgg, sbg, sag)
			sd = velocity * 0.3
		else
			rect(getui(x) + 52, getui(y) + 54, 97.5, 5, srg, sgg, sbg, sag)
			sd = 97.5
		end

		--fps--
		text(getui(x) + 5, getui(y) + 65, 255, 255, 255, 255, "", 0, "Fps")
		rect(getui(x) + 51, getui(y) + 68, 99.5, 7, 0, 0, 0, 255)
		if fps() * 0.675 <= 97.5 then
			rect(getui(x) + 52, getui(y) + 69, fps() * 0.675 - 0, 5, frg, fgg, fbg, fag)
			fd = fps() * 0.675
		else
			rect(getui(x) + 52, getui(y) + 69, 97.5, 5, frg, fgg, fbg, fag)
			fd = 97.5
		end

		--numcheck--
		if getui(numcheck, true) then
			text(getui(x) + 52 + pd, getui(y) + 11, 255, 255, 255, 255, "c", 0, ping)
			text(getui(x) + 52 + ld, getui(y) + 26, 255, 255, 255, 255, "c", 0, delay)
			text(getui(x) + 52 + choke * 6.964285714285714, getui(y) + 41, 255, 255, 255, 255, "c", 0, choke)
			text(getui(x) + 52 + sd, getui(y) + 56, 255, 255, 255, 255, "c", 0, velocity)
			text(getui(x) + 52 + fd, getui(y) + 71, 255, 255, 255, 255, "c", 0, fps())
		end
	end
end

callback('paint', Bars)

-- SKEET <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

local function Skeet(ctx)
	if getui(style) == "Skeet" then
		local w = 247
		local h = 90

		--BACKGROUND--
		rect(getui(x), getui(y), w, h + 10, 10, 10, 10, 255)
		rect(getui(x) + 1, getui(y) + 1, w - 2, h + 8, 60, 60, 60, 255)
		rect(getui(x) + 2, getui(y) + 2, w - 4, h + 6, 40, 40, 40, 255)
		rect(getui(x) + 5, getui(y) + 4, w - 9, h + 2, 60, 60, 60, 255)
		rect(getui(x) + 6, getui(y) + 5, w - 11, h, 20, 20, 20, 255)
		gradient(getui(x) + 7, getui(y) + 6, w / 2 - 11, 1, 56, 176, 218, 255, 201, 72, 205, 255, true)
		gradient(getui(x) + 7 + w / 2 - 13, getui(y) + 6, w / 2, 1, 201, 72, 205, 255, 204, 227, 53, 255, true)

		--PING--
		text(getui(x) + 15, getui(y) + 15, 255, 255, 255, 255, "", 0, "Ping:")
		rect(getui(x) + 79, getui(y) + 17, 152, 8, 0, 0, 0, 255)								-- hehe 69 ;) --
		rect(getui(x) + 80, getui(y) + 18, 150, 6, 29, 29, 29, 255)

		if ping <= 150 then
			rect(getui(x) + 80, getui(y) + 18, ping, 6, prg, pgg, pbg, pag)
		else
			rect(getui(x) + 80, getui(y) + 18, 150, 6, prg, pgg, pbg, pag)
		end

		--LATENCY--
		text(getui(x) + 15, getui(y) + 30, 255, 255, 255, 255, "", 0, "Latency:")
		rect(getui(x) + 79, getui(y) + 32, 152, 8, 0, 0, 0, 255)
		rect(getui(x) + 80, getui(y) + 33, 150, 6, 29, 29, 29, 255)

		if delay <= 150 then
			rect(getui(x) + 80, getui(y) + 33, latency, 6, lrg, lgg, lbg, lag)				--imagine lagging--
		else
			rect(getui(x) + 80, getui(y) + 33, 150, 6, lrg, lgg, lbg, lag)
		end

		--CHOKE--
		text(getui(x) + 15, getui(y) + 45, 255, 255, 255, 255, "", 0, "Choke:")
		rect(getui(x) + 79, getui(y) + 47, 152, 8, 0, 0, 0, 255)
		rect(getui(x) + 80, getui(y) + 48, 150, 6, 29, 29, 29, 255)

		rect(getui(x) + 80, getui(y) + 48, choke * 10.71428571428571, 6, crg, cgg, cbg, cag)
		
		--SPEED--
		text(getui(x) + 15, getui(y) + 60, 255, 255, 255, 255, "", 0, "Speed: ")
		rect(getui(x) + 79, getui(y) + 62, 152, 8, 0, 0, 0, 255)
		rect(getui(x) + 80, getui(y) + 63, 150, 6, 29, 29, 29, 255)

		if velocity <= 300 then
			rect(getui(x) + 80, getui(y) + 63, velocity / 2, 6, srg, sgg, sbg, sag)			--saggy tits--
		else
			rect(getui(x) + 80, getui(y) + 63, 150, 6, srg, sgg, sbg, sag)
		end

		--FPS--
		text(getui(x) + 15, getui(y) + 75, 255, 255, 255, 255, "", 0, "Fps:")
		rect(getui(x) + 79, getui(y) + 77, 152, 8, 0, 0, 0, 255)
		rect(getui(x) + 80, getui(y) + 78, 150, 6, 29, 29, 29, 255)

		if fps() <= 150 then
			rect(getui(x) + 80, getui(y) + 78, fps(), 6, frg, fgg, fbg, fag)				--ha gey--
		else
			rect(getui(x) + 80, getui(y) + 78, 150, 6, frg, fgg, fbg, fag)
		end

		--NUMCHECK--
		if getui(numcheck, true) then
			text(getui(x) + 42, getui(y) + 15, 255, 255, 255, 255, "", 0, ping)
			text(getui(x) + 60, getui(y) + 30, 255, 255, 255, 255, "", 0, latency)
			text(getui(x) + 52, getui(y) + 45, 255, 255, 255, 255, "", 0, choke)
			text(getui(x) + 51, getui(y) + 60, 255, 255, 255, 255, "", 0, velocity)
			text(getui(x) + 38, getui(y) + 75, 255, 255, 255, 255, "", 0, fps())
		end
	end
end

callback('paint', Skeet)
