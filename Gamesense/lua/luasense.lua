local user = "admin"
local function getbuild() return "beta" end
local function rgba(r, g, b, a, ...) return ("\a%x%x%x%x"):format(r, g, b, a) .. ... end
local vector = require("vector")
local notify=(function()local b=vector;local c=function(d,b,c)return d+(b-d)*c end;local e=function()return b(client.screen_size())end;local f=function(d,...)local c={...}local c=table.concat(c,"")return b(renderer.measure_text(d,c))end;local g={notifications={bottom={}},max={bottom=6}}g.__index=g;g.new_bottom=function(h,i,j,...)table.insert(g.notifications.bottom,{started=false,instance=setmetatable({active=false,timeout=5,color={["r"]=h,["g"]=i,["b"]=j,a=0},x=e().x/2,y=e().y,text=...},g)})end;function g:handler()local d=0;local b=0;for d,b in pairs(g.notifications.bottom)do if not b.instance.active and b.started then table.remove(g.notifications.bottom,d)end end;for d=1,#g.notifications.bottom do if g.notifications.bottom[d].instance.active then b=b+1 end end;for c,e in pairs(g.notifications.bottom)do if c>g.max.bottom then return end;if e.instance.active then e.instance:render_bottom(d,b)d=d+1 end;if not e.started then e.instance:start()e.started=true end end end;function g:start()self.active=true;self.delay=globals.realtime()+self.timeout end;function g:get_text()local d=""for b,b in pairs(self.text)do local c=f("",b[1])local c,e,f=255,255,255;if b[2]then c,e,f=99,199,99 end;d=d..("\a%02x%02x%02x%02x%s"):format(c,e,f,self.color.a,b[1])end;return d end;local k=(function()local d={}d.rec=function(d,b,c,e,f,g,k,l,m)m=math.min(d/2,b/2,m)renderer.rectangle(d,b+m,c,e-m*2,f,g,k,l)renderer.rectangle(d+m,b,c-m*2,m,f,g,k,l)renderer.rectangle(d+m,b+e-m,c-m*2,m,f,g,k,l)renderer.circle(d+m,b+m,f,g,k,l,m,180,.25)renderer.circle(d-m+c,b+m,f,g,k,l,m,90,.25)renderer.circle(d-m+c,b-m+e,f,g,k,l,m,0,.25)renderer.circle(d+m,b-m+e,f,g,k,l,m,-90,.25)end;d.rec_outline=function(d,b,c,e,f,g,k,l,m,n)m=math.min(c/2,e/2,m)if m==1 then renderer.rectangle(d,b,c,n,f,g,k,l)renderer.rectangle(d,b+e-n,c,n,f,g,k,l)else renderer.rectangle(d+m,b,c-m*2,n,f,g,k,l)renderer.rectangle(d+m,b+e-n,c-m*2,n,f,g,k,l)renderer.rectangle(d,b+m,n,e-m*2,f,g,k,l)renderer.rectangle(d+c-n,b+m,n,e-m*2,f,g,k,l)renderer.circle_outline(d+m,b+m,f,g,k,l,m,180,.25,n)renderer.circle_outline(d+m,b+e-m,f,g,k,l,m,90,.25,n)renderer.circle_outline(d+c-m,b+m,f,g,k,l,m,-90,.25,n)renderer.circle_outline(d+c-m,b+e-m,f,g,k,l,m,0,.25,n)end end;d.glow_module_notify=function(b,c,e,f,g,k,l,m,n,o,p,q,r,s,s)local t=1;local u=1;if s then d.rec(b,c,e,f,l,m,n,o,k)end;for l=0,g do local m=o/2*(l/g)^3;d.rec_outline(b+(l-g-u)*t,c+(l-g-u)*t,e-(l-g-u)*t*2,f-(l-g-u)*t*2,p,q,r,m/1.5,k+t*(g-l+u),t)end end;return d end)()function g:render_bottom(g,l)local e=e()local m=6;local n="     "..self:get_text()local f=f("",n)local o=8;local p=5;local q=0+m+f.x;local q,r=q+p*2,12+10+1;local s,t=self.x-q/2,math.ceil(self.y-40+.4)local u=globals.frametime()if globals.realtime()<self.delay then self.y=c(self.y,e.y-45-(l-g)*r*1.4,u*7)self.color.a=c(self.color.a,255,u*2)else self.y=c(self.y,self.y-10,u*15)self.color.a=c(self.color.a,0,u*20)if self.color.a<=1 then self.active=false end end;local c,e,g,l=self.color.r,self.color.g,self.color.b,self.color.a;k.glow_module_notify(s,t,q,r,15,o,25,25,25,l,179, 255, 18,l,true)local k=p+2;k=k+0+m;renderer.text(s+k,t+r/2-f.y/2,99,199,99,l,"b",nil,"L")renderer.text(s+k,t+r/2-f.y/2,c,e,g,l,"",nil,n)end;client.set_event_callback("paint_ui",function()g:handler()end)return g end)()
notify.new_bottom(179, 255, 18, { { 'Loading' }, { "... ", true }, })
local w, h = client.screen_size()
local js = panorama.open()
local alpha = 69
local toggled = false
client.set_event_callback("paint_ui", function()
	if alpha > 0 and toggled then
		if alpha == 169 then
			notify.new_bottom(179, 255, 18, { { 'Welcome: ' }, { user .. " ", true } }) 
		end
		alpha = alpha - 0.5
	else
		if not toggled then
			alpha = alpha + 1
			if alpha == 254 then
				toggled = true
			end
			alpha = alpha + 1
		end
	end
	if alpha > 1 then
		renderer.gradient(0,0,w,h,0,0,0,alpha,0,0,0,alpha,false)
	end
end)
return (function(tbl)
    tbl.items = {
        enabled = tbl.ref("aa", "anti-aimbot angles", "enabled"),
        pitch = tbl.ref("aa", "anti-aimbot angles", "pitch"),
        base = tbl.ref("aa", "anti-aimbot angles", "yaw base"),
        jitter = tbl.ref("aa", "anti-aimbot angles", "yaw jitter"),
        yaw = tbl.ref("aa", "anti-aimbot angles", "yaw"),
        body = tbl.ref("aa", "anti-aimbot angles", "body yaw"),
        fsbody = tbl.ref("aa", "anti-aimbot angles", "freestanding body yaw"),
        edge = tbl.ref("aa", "anti-aimbot angles", "edge yaw"),
        roll = tbl.ref("aa", "anti-aimbot angles", "roll"),
        fs = tbl.ref("aa", "anti-aimbot angles", "freestanding")
    }
    local prefix = function(x, z) 
        return (z and ("\a32a852FFluasense \a698a6dFF~ \a414141FF(\ab5b5b5FF%s\a414141FF) \a89f596FF%s"):format(x, z) or ("\a32a852FFluasense \a698a6dFF~ \a89f596FF%s"):format(x)) 
    end
    local ffi = require("ffi")
    local clipboard = {
        ["ffi"] = ffi.cdef([[
            typedef int(__thiscall* get_clipboard_text_count)(void*);
            typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
            typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
        ]]),
        ["export"] = function(arg)
            local pointer = ffi.cast(ffi.typeof('void***'), client.create_interface('vgui2.dll', 'VGUI_System010'))
            local func = ffi.cast('set_clipboard_text', pointer[0][9])
            func(pointer, arg, #arg)
        end,
        ["import"] = function()
            local pointer = ffi.cast(ffi.typeof('void***'), client.create_interface('vgui2.dll', 'VGUI_System010'))
            local func = ffi.cast('get_clipboard_text_count', pointer[0][7])
            local sizelen = func(pointer)
            local output = ""
            if sizelen > 0 then
                local buffer = ffi.new("char[?]", sizelen)
                local sizefix = sizelen * ffi.sizeof("char[?]", sizelen)
                local extrafunc = ffi.cast('get_clipboard_text', pointer[0][11])
                extrafunc(pointer, 0, buffer, sizefix)
                output = ffi.string(buffer, sizelen-1)
            end
            return output
        end
    }
    local category = ui.new_combobox("aa", "anti-aimbot angles", prefix("category" .. rgba(69,169,155,255," " .. (getbuild() == "beta" and " (beta)" or ""))), {"anti aimbot", "visuals & misc", "config"})
    local aa = {}
    local menu = {}
	local notifications = {}
	local draw_gamesense_ui = {}
	draw_gamesense_ui.alpha = function(color, alpha)
		color[4] = alpha
		return color
	end
	draw_gamesense_ui.colors = {
		main = {12, 12, 12},
		border_edge = {60, 60, 60},
		border_inner = {40, 40, 40},
		gradient = {
			top = {
				left = {55, 177, 218},
				middle = {204, 70, 205},
				right = {204, 227, 53}
			},
			bottom = {
				left = {29, 94, 116},
				middle = {109, 37, 109},
				right = {109, 121, 28}
			},
			pixel_three = {6, 6, 6}
		},
		combine = function(color1, color2, ...)
			local t = {unpack(color1)}
			for i = 1, #color2 do
				table.insert(t, color2[i])
			end
			local args = {...}
			for i = 1, #args do
				table.insert(t, args[i])
			end
			return t
		end
	}
	draw_gamesense_ui.border = function(x, y, width, height, alpha)
		local x = x - 7 - 1
		local y = y - 7 - 5
		local w = width + 14 + 2
		local h = height + 14 + 10
		renderer.rectangle(x, y, w, h, unpack(draw_gamesense_ui.alpha(draw_gamesense_ui.colors.main, alpha)))
		renderer.rectangle(x + 1, y + 1, w - 2, h - 2, unpack(draw_gamesense_ui.alpha(draw_gamesense_ui.colors.border_edge, alpha)))
		renderer.rectangle(x + 2, y + 2, w - 4, h - 4, unpack(draw_gamesense_ui.alpha(draw_gamesense_ui.colors.border_inner, alpha)))
		renderer.rectangle(x + 6, y + 6, w - 12, h - 12, unpack(draw_gamesense_ui.alpha(draw_gamesense_ui.colors.border_edge, alpha)))
	end
	draw_gamesense_ui.gradient = function(x, y, width, alpha)
		local full_width = width
		local width = math.floor(width / 2)
		local top_left = draw_gamesense_ui.alpha(draw_gamesense_ui.colors.gradient.top.left, alpha)
		local top_middle = draw_gamesense_ui.alpha(draw_gamesense_ui.colors.gradient.top.middle, alpha)
		local top_right = draw_gamesense_ui.alpha(draw_gamesense_ui.colors.gradient.top.right, alpha)
		local bottom_left = draw_gamesense_ui.alpha(draw_gamesense_ui.colors.gradient.bottom.left, alpha)
		local bottom_middle = draw_gamesense_ui.alpha(draw_gamesense_ui.colors.gradient.bottom.middle, alpha)
		local bottom_right = draw_gamesense_ui.alpha(draw_gamesense_ui.colors.gradient.bottom.right, alpha)
		top_left = draw_gamesense_ui.colors.combine(top_left, top_middle, true)
		top_right = draw_gamesense_ui.colors.combine(top_middle, top_right, true)
		bottom_left = draw_gamesense_ui.colors.combine(bottom_left, bottom_middle, true)
		bottom_right = draw_gamesense_ui.colors.combine(bottom_middle, bottom_right, true)
		local oddfix = math.ceil(full_width / 2)
		renderer.gradient(x, y - 4, width, 1, unpack(top_left))
		renderer.gradient(x + width, y - 4, oddfix, 1, unpack(top_right))
		renderer.gradient(x, y - 3, width, 1, unpack(bottom_left))
		renderer.gradient(x + width, y - 3, oddfix, 1, unpack(bottom_right))
		renderer.rectangle(x, y - 2, full_width, 1, unpack(draw_gamesense_ui.colors.gradient.pixel_three))
	end
	draw_gamesense_ui.draw = function(x, y, width, height, alpha)
		y = y - 7
		draw_gamesense_ui.border(x, y, width, height, alpha)
		renderer.rectangle(x - 1, y - 5, width + 2, height + 10, unpack(draw_gamesense_ui.alpha(draw_gamesense_ui.colors.main, alpha)))
		draw_gamesense_ui.gradient(x, y, width, alpha)
	end
	local function push_notify(text)
        if tbl.contains(ui.get(menu["visuals & misc"]["visuals"]["notify"]), "old") then
            notify.new_bottom(179, 255, 18, { { text } }) 
        else
            table.insert(notifications, 1, {
                text = text,
                alpha = 255,
                spacer = 0,
                lifetime = client.timestamp() + (10.0 * 100),
            })
        end
    end
	local lerp = function(current, to_reach, t) return current + (to_reach - current) * t end
	client.set_event_callback("paint_ui", function()
		local width, height = client.screen_size()
		local frametime = globals.frametime()
		local timestamp = client.timestamp()
		for idx, notification in next, notifications do
			if timestamp > notification.lifetime then
				notification.alpha = lerp(255, 0, 1 - (notification.alpha / 255) + frametime * (1 / 7.5 * 10))
			end
			if notification.alpha <= 0 then
				notifications[idx] = nil
			else
				notification.spacer = lerp(notification.spacer, idx * 40, frametime)
				local text_width = renderer.measure_text("c", notification.text) + 10
				draw_gamesense_ui.draw(width/2 - text_width / 2, height/2 + 300 + notification.spacer, text_width, 12, notification.alpha)
				renderer.text(width/2, height/2 + 300 + notification.spacer, 255, 255, 255, notification.alpha, "c", 0, notification.text:gsub("\a%x%x%x%x%x%x%x%x", function(color)
					return color:sub(1, #color - 2)..string.format("%02x", notification.alpha)
				end):sub(1, -1))
			end
		end
	end)
    menu = {
        ["anti aimbot"] = {
            submenu = ui.new_combobox("aa", "anti-aimbot angles", "\nmenu", {"builder", "keybinds", "features"}),
            ["builder"] = {
                builder = ui.new_combobox("aa", "anti-aimbot angles", prefix("builder"), tbl.states),
                team = ui.new_combobox("aa", "anti-aimbot angles", "\nteam", {"ct", "t"})
            },
            ["keybinds"] = {
                keys = ui.new_multiselect("aa", "anti-aimbot angles", prefix("keys"), {"manual", "edge", "freestand"}),
                left = ui.new_hotkey("aa", "anti-aimbot angles", prefix("left")),
                right = ui.new_hotkey("aa", "anti-aimbot angles", prefix("right")),
                forward = ui.new_hotkey("aa", "anti-aimbot angles", prefix("forward")),
                backward = ui.new_hotkey("aa", "anti-aimbot angles", prefix("backward")),
                type_manual = ui.new_combobox("aa", "anti-aimbot angles", prefix("manual"), {"default", "jitter", "static"}),
                edge = ui.new_hotkey("aa", "anti-aimbot angles", prefix("edge")),
                type_freestand = ui.new_combobox("aa", "anti-aimbot angles", prefix("freestand"), {"default", "jitter", "static"}),
                freestand = ui.new_hotkey("aa", "anti-aimbot angles", "\nfreestand", true),
                disablers = ui.new_multiselect("aa", "anti-aimbot angles", prefix("fs disablers"), {"air", "slow", "duck", "edge", "manual", "fake lag"})
            },
            ["features"] = {
                legit = ui.new_combobox("aa", "anti-aimbot angles", prefix("legit"), {"off", "default", "luasense"}),
                fix = ui.new_multiselect("aa", "anti-aimbot angles", "\nfix", {"generic", "bombsite"}),
				defensive = ui.new_combobox("aa", "anti-aimbot angles", prefix("defensive"), {"off", "pitch", "spin", "random", "random pitch", "sideways down", "sideways up"}),
                fixer = ui.new_combobox("aa", "anti-aimbot angles", "\nfixer", {"default", "luasense"}),
				states = ui.new_multiselect("aa", "anti-aimbot angles", "\nstates\n", {"standing", "moving", "air", "air duck", "duck", "duck moving", "slow motion"}),
                backstab = ui.new_combobox("aa", "anti-aimbot angles", prefix("backstab"), {"off", "forward", "random"}),
                distance = ui.new_slider("aa", "anti-aimbot angles", "\nbackstab", 100, 500, 250),
                roll = ui.new_slider("aa", "anti-aimbot angles", prefix("roll"), -45, 45, 0)
            },
        },
        ["visuals & misc"] = {
            submenu = ui.new_combobox("aa", "anti-aimbot angles", "\nvisuals & misc", {"visuals", "misc"}),
            ["visuals"] = {
                watermark = ui.new_combobox("aa", "anti-aimbot angles", prefix("always on", "watermark"), {"bottom", "right", "left"}),
                watermark_color = ui.new_color_picker("aa", "anti-aimbot angles", "\nwatermark", 150, 200, 69, 255),
                watermark_spaces = ui.new_combobox("aa", "anti-aimbot angles", prefix("remove spaces"), {"yes", "no"}),
                notify = ui.new_multiselect("aa", "anti-aimbot angles", prefix("notify"), {"hit", "miss", "shot", "reset", "old"}),
                arrows = ui.new_combobox("aa", "anti-aimbot angles", prefix("arrows"), {"-", "simple", "body", "luasense"}),
                arrows_color = ui.new_color_picker("aa", "anti-aimbot angles", "\narrows", 137, 245, 150, 255),
                indicators = ui.new_combobox("aa", "anti-aimbot angles", prefix("indicators"), {"-", "default"}),
                indicators_color = ui.new_color_picker("aa", "anti-aimbot angles", "\nindicators", 137, 245, 150, 255),
            },
            ["misc"] = {
                features = ui.new_multiselect("aa", "anti-aimbot angles", prefix("features"), {"fix hideshot", "animations", "legs spammer"}),
                spammer = ui.new_slider("aa", "anti-aimbot angles", "\nspammer", 1, 9, 1),
                autobuy = ui.new_combobox("aa", "anti-aimbot angles", prefix("auto buy"), {"off", "awp", "scout"})
            }
        },
        ["config"] = {
            export = ui.new_button("aa", "anti-aimbot angles", "\a89f596FF export", function()
                local tbl = {}
                for i, v in next, aa do
                    tbl[i] = {}
                    for index, value in next, v do
                        tbl[i][index] = {}
                        for ii, vv in next, value do
                            if ii == "type" then
                                tbl[i][index][ii] = ui.get(vv)
                            else
                                if ii ~= "button" then
                                    tbl[i][index][ii] = {}
                                    for iii, vvv in next, vv do
                                        tbl[i][index][ii][iii] = ui.get(vvv)
                                    end
                                end
                            end
                        end
                    end
                end
                tbl["extra"] = {}
                for i, v in next, menu["anti aimbot"] do
                    if i == "submenu" then
                        tbl["extra"][i] = ui.get(v)
                    else
                        tbl["extra"][i] = {}
                        for index, value in next, v do
                            local fixer = true
                            if i == "keybinds" then
                                if index == "left" or index == "right" or index == "forward" or index == "backward" or index == "edge" or index == "freestand" then
                                    fixer = false
                                end
                            end
                            if fixer then
                                tbl["extra"][i][index] = ui.get(value)
                            end
                        end
                    end
                end
				push_notify("Exported config!")
                clipboard.export(json.stringify({["LUASENSE"] = tbl}))
            end),
            import = ui.new_button("aa", "anti-aimbot angles", "\a32a852FF import", function()
                local check, message = pcall(function()
                    local tbl = json.parse(clipboard.import())
                    for i, v in next, tbl["LUASENSE"]["extra"] do
                        if i == "submenu" then
                            ui.set(menu["anti aimbot"][i], v)
                        else
                            for index, value in next, v do
                                ui.set(menu["anti aimbot"][i][index], value)
                            end
                        end
                    end
                    tbl["LUASENSE"]["extra"] = nil
                    for i, v in next, tbl["LUASENSE"] do
                        for index, value in next, v do
                            for ii, vv in next, value do
                                if ii == "type" then
                                    ui.set(aa[i][index][ii], vv)
                                else
                                    for iii, vvv in next, vv do
                                        ui.set(aa[i][index][ii][iii], vvv)
                                    end
                                end
                            end
                        end
                    end
                end)
				push_notify(check and "Imported config!" or "Error while importing!")
            end),
        }
    }
    for i, v in next, tbl.states do
        aa[v] = {}
        for index, value in next, {"ct", "t"} do
            aa[v][value] = {
                ["type"] = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "type"), (v == "global" and {"normal", "luasense", "advanced", "auto"} or {"disabled", "normal", "luasense", "advanced", "auto"})),
                ["normal"] = {
                    mode = ui.new_multiselect("aa", "anti-aimbot angles", prefix(v .. " " .. value, "mode"), {"yaw", "left right"}),
                    yaw = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "yaw"), -180, 180, 0),
                    left = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "left"), -180, 180, 0),
                    right = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "right"), -180, 180, 0),
                    method = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "method"), {"default", "luasense"}),
                    jitter = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "jitter"), {"off", "offset", "center", "random", "skitter"}),
                    jitter_slider = ui.new_slider("aa", "anti-aimbot angles", "\njitter slider " .. v .. " " .. value, -180, 180, 0),
                    body = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "body"), {"off", "luasense", "opposite", "static", "jitter"}),
                    body_slider = ui.new_slider("aa", "anti-aimbot angles", "\nbody slider " .. v .. " " .. value, -180, 180, 0),
                    custom_slider = ui.new_slider("aa", "anti-aimbot angles", "\ncustom slider " .. v .. " " .. value, 0, 60, 60),
                    defensive = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "defensive"), {"off", "always on", "luasense"})
                },
                ["luasense"] = {
                    luasense = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "luasense"), 1, 10, 1),
                    mode = ui.new_multiselect("aa", "anti-aimbot angles", prefix(v .. " " .. value, "mode\n"), {"yaw", "left right"}),
                    yaw = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "yaw\n"), -180, 180, 0),
                    left = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "left\n"), -180, 180, 0),
                    right = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "right\n"), -180, 180, 0),
                    fake = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "fake"), 0, 60, 60),
                    defensive = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "defensive\n"), {"off", "always on", "luasense"})
                },
				["advanced"] = {
					--trigger = tbl.item("new_combobox", {rgba(69,169,55,255,v .. ": ") .. rgba(69,169,155,255,"Trigger"), "A: Brandon", "B: Best", "C: Experimental", "Automatic"}),
					trigger = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "trigger"), "a: brandon", "b: best", "c: experimental", "automatic"),
					left = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "left\n\n"), -180, 180, 0),
                    right = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "right\n\n"), -180, 180, 0),
					defensive = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "defensive\n\n\n"), {"off", "always on", "luasense"})
				},
                ["auto"] = {
                    method = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "method\n"), {"simple", "luasense"}),
                    timer = ui.new_slider("aa", "anti-aimbot angles", "\ntimer", 50, 250, 150),
					left = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "left\n\n\n"), -180, 180, 0),
                    right = ui.new_slider("aa", "anti-aimbot angles", prefix(v .. " " .. value, "right\n\n\n"), -180, 180, 0),
                    antibf = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "bruteforce"), {"no", "yes"}),
                    defensive = ui.new_combobox("aa", "anti-aimbot angles", prefix(v .. " " .. value, "defensive\n\n"), {"off", "always on", "luasense"})
                },
                ["disabled"] = {},
                ["button"] = ui.new_button("aa", "anti-aimbot angles", "\a32a852FFsend to \a89f596FF" .. (value == "t" and "ct" or "t"), function()
                    local state = ui.get(menu["anti aimbot"]["builder"]["builder"])
                    local team = ui.get(menu["anti aimbot"]["builder"]["team"])
                    local target = (team == "t" and "ct" or "t")
                    for i, v in next, aa[state][team] do
                        if i ~= "button" then
                            if i == "type" then
                                ui.set(aa[state][target][i], ui.get(v))
                            else
                                for index, value in next, v do
                                    ui.set(aa[state][target][i][index], ui.get(value))
                                end
                            end
                        end
                    end
                end)
            }
        end
    end
    tbl.refs = {
        slow = tbl.ref("aa", "other", "slow motion"),
        hide = tbl.ref("aa", "other", "on shot anti-aim"),
        dt = tbl.ref("rage", "aimbot", "double tap")
    }
    tbl.antiaim = {
        luasensefake = false,
        autocheck = false,
        current = false,
        active = false,
        count = false,
		ready = false,
        timer = 0,
        fs = 0,
        last = 0,
        log = {},
        manual = {
            aa = 0,
            tick = 0
        }
    }
    local distance = function(x1,y1,z1,x2,y2,z2)
		return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
	end
	local extrapolate = function(player, ticks, x,y,z)
		local xv, yv, zv =  entity.get_prop(player, "m_vecVelocity")
		local new_x = x + globals.tickinterval() * xv * ticks
		local new_y = y + globals.tickinterval() * yv * ticks
		local new_z = z + globals.tickinterval() * zv * ticks
		return new_x, new_y, new_z
	end
    local function calcangle(localplayerxpos, localplayerypos, enemyxpos, enemyypos)
       local relativeyaw = math.atan( (localplayerypos - enemyypos) / (localplayerxpos - enemyxpos) )
       return relativeyaw * 180 / math.pi
    end
    local function angle_vector(angle_x, angle_y)
        local sp, sy, cp, cy = nil
        sy = math.sin(math.rad(angle_y));
        cy = math.cos(math.rad(angle_y));
        sp = math.sin(math.rad(angle_x));
        cp = math.cos(math.rad(angle_x));
        return cp * cy, cp * sy, -sp;
    end
    local enemy_visible = function(x)
        if not (entity.is_alive(x) and not entity.is_dormant(x)) then 
            return false 
        end
        for i=0, 18 do 
            if client.visible(entity.hitbox_position(x, i)) then
                return true 
            end 
        end 
        return false
    end
    local function get_camera_pos(enemy)
		local e_x, e_y, e_z = entity.get_prop(enemy, "m_vecOrigin")
		if e_x == nil then return end
		local _, _, ofs = entity.get_prop(enemy, "m_vecViewOffset")
		e_z = e_z + (ofs - (entity.get_prop(enemy, "m_flDuckAmount") * 16))
		return e_x, e_y, e_z
	end
	local function fired_at(target, shooter, shot)
		local shooter_cam = { get_camera_pos(shooter) }
		if shooter_cam[1] == nil then return end
		local player_head = { entity.hitbox_position(target, 0) }
		local shooter_cam_to_head = { player_head[1] - shooter_cam[1],player_head[2] - shooter_cam[2],player_head[3] - shooter_cam[3] }
		local shooter_cam_to_shot = { shot[1] - shooter_cam[1], shot[2] - shooter_cam[2],shot[3] - shooter_cam[3]}
		local magic = ((shooter_cam_to_head[1]*shooter_cam_to_shot[1]) + (shooter_cam_to_head[2]*shooter_cam_to_shot[2]) + (shooter_cam_to_head[3]*shooter_cam_to_shot[3])) / (math.pow(shooter_cam_to_shot[1], 2) + math.pow(shooter_cam_to_shot[2], 2) + math.pow(shooter_cam_to_shot[3], 2))
		local closest = { shooter_cam[1] + shooter_cam_to_shot[1]*magic, shooter_cam[2] + shooter_cam_to_shot[2]*magic, shooter_cam[3] + shooter_cam_to_shot[3]*magic}
		local length = math.abs(math.sqrt(math.pow((player_head[1]-closest[1]), 2) + math.pow((player_head[2]-closest[2]), 2) + math.pow((player_head[3]-closest[3]), 2)))
		local frac_shot = client.trace_line(shooter, shot[1], shot[2], shot[3], player_head[1], player_head[2], player_head[3])
		local frac_final = client.trace_line(target, closest[1], closest[2], closest[3], player_head[1], player_head[2], player_head[3])
		return (length < 69) and (frac_shot > 0.99 or frac_final > 0.99)
	end
	local tickshot = 0
	client.set_event_callback("bullet_impact", function(event)
		if entity.get_local_player() == nil then return end
		local enemy = client.userid_to_entindex(event.userid)
		local lp = entity.get_local_player()
		if enemy == entity.get_local_player() or not entity.is_enemy(enemy) or not entity.is_alive(lp) then return nil end
		if fired_at(lp, enemy, {event.x, event.y, event.z}) then
			if tickshot ~= globals.tickcount() then
				if tbl.contains(ui.get(menu["visuals & misc"]["visuals"]["notify"]), "shot") then
					push_notify("Detected a shot!")
				end
				tickshot = globals.tickcount()
                tbl.antiaim.count = true
                tbl.antiaim.timer = 0
                if tbl.antiaim.active and tbl.antiaim.log[enemy] == nil then
                    tbl.antiaim.log[enemy] = not tbl.antiaim.current
                else
				    tbl.antiaim.log[enemy] = not tbl.antiaim.log[enemy]
                end
			end
		end
	end)
	local hitboxes = { [0] = 'body', 'head', 'chest', 'stomach', 'arm', 'arm', 'leg', 'leg', 'neck', 'body', 'body' }
	client.set_event_callback('aim_miss', function(shot)
		if not tbl.contains(ui.get(menu["visuals & misc"]["visuals"]["notify"]), "miss") then return nil end
		local target = entity.get_player_name(shot.target):lower()
		local hitbox = hitboxes[shot.hitgroup] or "?"
		push_notify("Missed " .. target .. "'s " .. hitbox .. " due to " .. shot.reason .. "!")
	end)
	client.set_event_callback('aim_hit', function(shot)
		if not tbl.contains(ui.get(menu["visuals & misc"]["visuals"]["notify"]), "hit") then return nil end
		local target = entity.get_player_name(shot.target):lower()
		local hitbox = hitboxes[shot.hitgroup] or "?"
		push_notify("Hit " .. target .. "'s " .. hitbox .. " for " .. shot.damage .. "!")
	end)
	local z = {}
	z.defensive = {
		cmd = 0,
		check = 0,
		defensive = 0,
		run = function(arg)
			z.defensive.cmd = arg.command_number
			ladder = (entity.get_prop(z, "m_MoveType") == 9)
		end,
		predict = function(arg)
			if arg.command_number == z.defensive.cmd then
				local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
				z.defensive.defensive = math.abs(tickbase - z.defensive.check)
				z.defensive.check = math.max(tickbase, z.defensive.check or 0)
				z.defensive.cmd = 0
			end
		end
	}
	client.set_event_callback("level_init", function()
		z.defensive.check, z.defensive.defensive = 0, 0
	end)
	local scope_fix = false
	local scope_int = 0
	local shift_int = 0
	local list_shift = (function()
		local index, max = { }, 16
		for i=1, max do
			index[#index+1] = 0
			if i == max then
				return index
			end
		end
	end)()
	z.dtshift = function()
		local local_player = entity.get_local_player()
		local sim_time = entity.get_prop(local_player, "m_flSimulationTime")
		if local_player == nil or sim_time == nil then
			return
		end
		local tick_count = globals.tickcount()
		local shifted = math.max(unpack(list_shift))
		shift_int = shifted < 0 and math.abs(shifted) or 0
		list_shift[#list_shift+1] = sim_time/globals.tickinterval() - tick_count
		table.remove(list_shift, 1)
	end
	client.set_event_callback("net_update_start", z.dtshift)
	client.set_event_callback("run_command", z.defensive.run)
	client.set_event_callback("predict_command", z.defensive.predict)
	local animkeys = {
		dt = 0,
		duck = 0,
		hide = 0,
		safe = 0,
		baim = 0,
		fs = 0
	}
	local gradient = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
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
	z.items = {}
	z.items.keys = { 
		dt = {ui.reference("rage", "aimbot", "double tap")},
        hs = {ui.reference("aa", "other", "on shot anti-aim")},
		fd = {ui.reference("rage", "other", "duck peek assist")},
		sp = {ui.reference("rage", "aimbot", "force safe point")},
		fb = {ui.reference("rage", "aimbot", "force body aim")}
    }
    local limitfl = ui.reference("aa", "fake lag", "limit")
    local legs = ui.reference("aa", "other", "leg movement")
    local spammer = 0
	tbl.tick_aa = -2147483500
	tbl.list_aa = {}
	tbl.reset_aa = false
	tbl.defensive_aa = 1337
	tbl.callbacks = {
        ["freestand"] = function()
            local result = 0
            local player = client.current_threat()
            if player ~= nil and not enemy_visible(player) then
                local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
                local enemyx, enemyy, enemyz = entity.get_prop(player, "m_vecOrigin")
                local yaw = calcangle(lx, ly, enemyx, enemyy)
                local dir_x, dir_y = angle_vector(0, (yaw + 90))
                local end_x = lx + dir_x * 55
                local end_y = ly + dir_y * 55
                local end_z = lz + 80
                local index, damage = client.trace_bullet(player, enemyx, enemyy, enemyz + 70, end_x, end_y, end_z,true)
                if damage > 0 then result = 1 end
                dir_x, dir_y = angle_vector(0, (yaw + -90))
                end_x = lx + dir_x * 55
                end_y = ly + dir_y * 55
                end_z = lz + 80
                index, damage = client.trace_bullet(player, enemyx, enemyy, enemyz + 70, end_x, end_y, end_z,true)
                if damage > 0 then 
                    if result == 1 then 
                        result = 0 
                    else 
                        result = -1 
                    end 
                end
            end
            tbl.antiaim.fs = result
        end,
        ["command"] = function(arg)
            local myself = entity.get_local_player()
			local air = bit.band(entity.get_prop(myself, "m_fFlags"), 1) == 0
            local xv, yv, zv = entity.get_prop(myself, "m_vecVelocity")
			local duck = (entity.get_prop(myself, "m_flDuckAmount") > 0.1)
            local team = (entity.get_prop(myself, "m_iTeamNum") == 2 and "t" or "ct")
            local fakelag = not ((ui.get(tbl.refs.dt[1]) and ui.get(tbl.refs.dt[2])) or (ui.get(tbl.refs.hide[1]) and ui.get(tbl.refs.hide[2])))
            local real_state = tbl.getstate(arg.in_jump == 1 or air, duck, math.sqrt(xv*xv + yv*yv + zv*zv), (ui.get(tbl.refs.slow[1]) and ui.get(tbl.refs.slow[2])))
            local hideshot = ((ui.get(tbl.refs.hide[1]) and ui.get(tbl.refs.hide[2])) and not (ui.get(tbl.refs.dt[1]) and ui.get(tbl.refs.dt[2])))
            local state = real_state
            if fakelag and ui.get(aa["fake lag"][team]["type"]) ~= "disabled" then
                state = "fake lag"
            elseif hideshot and ui.get(aa["hide shot"][team]["type"]) ~= "disabled" then
                state = "hide shot"
            elseif ui.get(aa[state][team]["type"]) == "disabled" then
                state = "global"
            else end
            local enemy = client.current_threat()
            local menutbl = aa[state][team]
            ui.set(tbl.items.enabled[1], true)
			ui.set(tbl.items.base[1], "at targets")
			ui.set(tbl.items.pitch[1], "default")
			ui.set(tbl.items.yaw[1], "180")
            ui.set(tbl.items.fsbody[1], false)
			ui.set(tbl.items.edge[1], false)
			ui.set(tbl.items.fs[1], false)
			ui.set(tbl.items.fs[2], "always on")
            ui.set(tbl.items.roll[1], 0)
            arg.roll = ui.get(menu["anti aimbot"]["features"]["roll"])
            local myweapon = entity.get_player_weapon(myself)
            if ui.get(menu["anti aimbot"]["features"]["legit"]) ~= "off" and arg.in_use == 1 and entity.get_classname(myweapon) ~= "CC4" then
                if tbl.contains(ui.get(menu["anti aimbot"]["features"]["fix"]), "generic") then
                    if arg.chokedcommands ~= 1 then
                        arg.in_use = 0
                    end
                else
                    arg.in_use = 0
                end
                if tbl.contains(ui.get(menu["anti aimbot"]["features"]["fix"]), "bombsite") then
                    local player_x, player_y, player_z = entity.get_prop(myself, "m_vecOrigin")
                    local distance_bomb = 100
                    local bomb = entity.get_all("CPlantedC4")[1]
                    local bomb_x, bomb_y, bomb_z = entity.get_prop(bomb, "m_vecOrigin")
                    if bomb_x ~= nil then
                        distance_bomb = distance(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
                    end
                    local distance_hostage = 100
                    local hostage = entity.get_all("CPlantedC4")[1]
                    local hostage_x, hostage_y, hostage_z = entity.get_prop(bomb, "m_vecOrigin")
                    if hostage_x ~= nil then
                        distance_hostage = distance(hostage_x, hostage_y, hostage_z, player_x, player_y, player_z)
                    end
                    if (distance_bomb < 69) or (distance_hostage < 69) then
                        arg.in_use = 1
                    end
                end
                ui.set(tbl.items.base[1], "local view")
			    ui.set(tbl.items.pitch[1], "off")
                ui.set(tbl.items.fsbody[1], true)
                ui.set(tbl.items.yaw[2], 180)
                ui.set(tbl.items.jitter[1], "off")
                ui.set(tbl.items.jitter[2], 0)
                if ui.get(menu["anti aimbot"]["features"]["legit"]) == "default" or tbl.antiaim.fs == 0 then
                    ui.set(tbl.items.body[1], ui.get(menu["anti aimbot"]["features"]["legit"]) == "default" and "opposite" or "jitter")
                    ui.set(tbl.items.body[2], 0)
                else
                    ui.set(tbl.items.body[1], "static")
                    ui.set(tbl.items.body[2], tbl.antiaim.fs == 1 and -180 or 180)
                    if arg.chokedcommands == 0 then
                        arg.allow_send_packet = false
                    end
                end
                arg.force_defensive = true
                return nil
            end
            if ui.get(menu["anti aimbot"]["features"]["backstab"]) ~= "off" and enemy ~= nil then
                local weapon = entity.get_player_weapon(enemy)
                if weapon ~= nil and entity.get_classname(weapon) == "CKnife" then
                    local ex,ey,ez = entity.get_origin(enemy)
					local lx,ly,lz = entity.get_origin(myself)
					if ex ~= nil and lx ~= nil then 
						for ticks = 1,9 do
							local tex,tey,tez = extrapolate(myself,ticks,lx,ly,lz)
							local distance = distance(ex,ey,ez,tex,tey,tez)
                            if math.abs(distance) < ui.get(menu["anti aimbot"]["features"]["distance"]) then
                                ui.set(tbl.items.yaw[2], ui.get(menu["anti aimbot"]["features"]["backstab"]) == "forward" and 180 or client.random_int(-180, 180))
                                ui.set(tbl.items.jitter[1], "off")
                                ui.set(tbl.items.jitter[2], 0)
                                ui.set(tbl.items.body[1], ui.get(menu["anti aimbot"]["features"]["backstab"]) == "random" and "jitter" or "opposite")
                                ui.set(tbl.items.body[2], 0)
                                arg.force_defensive = true
                                return nil
                            end
                        end
                    end
                end
            end
            if ui.get(menutbl["type"]) == "normal" then
                menutbl = menutbl[ui.get(menutbl["type"])]
                local yaw = tbl.antiaim.manual.aa
                if tbl.contains(ui.get(menutbl["mode"]), "yaw") then
                    yaw = tbl.antiaim.manual.aa + ui.get(menutbl["yaw"])
                end
                if tbl.contains(ui.get(menutbl["mode"]), "left right") then
                    local method = arg.chokedcommands == 0
                    if ui.get(menutbl["method"]) == "luasense" then
                        method = arg.chokedcommands ~= 0
                    end
                    if method and ui.get(menutbl["body"]) ~= "luasense" then
                        if math.max(-60, math.min(60, math.floor((entity.get_prop(myself,"m_flPoseParameter", 11) or 0)*120-60+0.5))) > 0 then
                            ui.set(tbl.items.yaw[2], tbl.clamp(yaw + ui.get(menutbl["right"])))
                        else
                            ui.set(tbl.items.yaw[2], tbl.clamp(yaw + ui.get(menutbl["left"])))
                        end
                    end
                else
                    ui.set(tbl.items.yaw[2], tbl.clamp(yaw))
                end
                ui.set(tbl.items.jitter[1], ui.get(menutbl["jitter"]))
                ui.set(tbl.items.jitter[2], ui.get(menutbl["jitter_slider"]))
                if ui.get(menutbl["body"]) ~= "luasense" then
                    ui.set(tbl.items.body[1], ui.get(menutbl["body"]))
                    ui.set(tbl.items.body[2], ui.get(menutbl["body_slider"]))
                else
                    ui.set(tbl.items.body[1], "static")
                    local fake = (ui.get(menutbl["custom_slider"])+1) * 2
                    local luasensefake = false
                    if arg.command_number % client.random_int(3,6) == 1 then
						tbl.antiaim.ready = true
                    end
					if tbl.antiaim.ready and arg.chokedcommands == 0 then
						tbl.antiaim.ready = false
						tbl.antiaim.luasensefake = not tbl.antiaim.luasensefake
                        ui.set(tbl.items.body[2], tbl.antiaim.luasensefake and -fake or fake)
                        luasensefake = true
					end
                    if tbl.contains(ui.get(menutbl["mode"]), "left right") then
                        if luasensefake then
                            if tbl.antiaim.luasensefake then
                                ui.set(tbl.items.yaw[2], tbl.clamp(yaw + ui.get(menutbl["right"])))
                            else
                                ui.set(tbl.items.yaw[2], tbl.clamp(yaw + ui.get(menutbl["left"])))
                            end
                        end
                    end
                end
                if ui.get(menutbl["defensive"]) == "luasense" then
                    arg.force_defensive = arg.command_number % 3 ~= 1 or arg.weaponselect ~= 0 or arg.quick_stop == 1
                elseif ui.get(menutbl["defensive"]) == "always on" then
                    arg.force_defensive = true
                else end
            elseif ui.get(menutbl["type"]) == "luasense" then
                menutbl = menutbl[ui.get(menutbl["type"])]
                ui.set(tbl.items.jitter[1], "off")
                ui.set(tbl.items.body[1], "static")
                if arg.command_number % (ui.get(menutbl["luasense"])+1+1) == 1 then
					tbl.antiaim.ready = true
                end
				if tbl.antiaim.ready and arg.chokedcommands == 0 then
					local fake = (ui.get(menutbl["fake"])+1) * 2
					tbl.antiaim.ready = false
                    tbl.antiaim.luasensefake = not tbl.antiaim.luasensefake
                    ui.set(tbl.items.body[2], tbl.antiaim.luasensefake and -fake or fake)
                    local yaw = tbl.antiaim.manual.aa
                    if tbl.contains(ui.get(menutbl["mode"]), "yaw") then
                        yaw = tbl.antiaim.manual.aa + ui.get(menutbl["yaw"])
                    end
                    if tbl.contains(ui.get(menutbl["mode"]), "left right") then
                        if tbl.antiaim.luasensefake then
                            ui.set(tbl.items.yaw[2], tbl.clamp(yaw + ui.get(menutbl["right"])))
                        else
                            ui.set(tbl.items.yaw[2], tbl.clamp(yaw + ui.get(menutbl["left"])))
                        end
                    else
                        ui.set(tbl.items.yaw[2], tbl.clamp(yaw))
                    end
				end
                if ui.get(menutbl["defensive"]) == "luasense" then
                    arg.force_defensive = arg.command_number % 3 ~= 1 or arg.weaponselect ~= 0 or arg.quick_stop == 1
                elseif ui.get(menutbl["defensive"]) == "always on" then
                    arg.force_defensive = true
                else end
			elseif ui.get(menutbl["type"]) == "advanced" then
                menutbl = menutbl[ui.get(menutbl["type"])]
                ui.set(tbl.items.jitter[1], "off")
                ui.set(tbl.items.body[1], "static")
                local trigger = client.random_int(3,6)
				if ui.get(menutbl["trigger"]) == "a: brandon" then
					trigger = 5
				end
				if ui.get(menutbl["trigger"]) == "b: best" then
					trigger = 6
				end
				if ui.get(menutbl["trigger"]) == "c: experimental" then
					if trigger == 1 or trigger == 1+1 then
						trigger = 9
					else
						trigger = trigger + 1
					end
				end
				if arg.command_number % trigger == 1 then
					tbl.auto = not tbl.auto
					if tbl.auto then
						ui.set(tbl.items.body[2], -123)
						ui.set(tbl.items.yaw[2], tbl.clamp(ui.get(menutbl["right"]) + tbl.antiaim.manual.aa))
					else
						ui.set(tbl.items.body[2], 123)
						ui.set(tbl.items.yaw[2], tbl.clamp(ui.get(menutbl["left"]) + tbl.antiaim.manual.aa))
					end
				end
                if ui.get(menutbl["defensive"]) == "luasense" then
                    arg.force_defensive = arg.command_number % 3 ~= 1 or arg.weaponselect ~= 0 or arg.quick_stop == 1
                elseif ui.get(menutbl["defensive"]) == "always on" then
                    arg.force_defensive = true
                else end
            elseif ui.get(menutbl["type"]) == "auto" then
                menutbl = menutbl[ui.get(menutbl["type"])]
                ui.set(tbl.items.jitter[1], "random")
                ui.set(tbl.items.body[1], "static")
                ui.set(tbl.items.yaw[2], tbl.antiaim.manual.aa)
                local check = arg.command_number % 10 > 5
                if tbl.antiaim.fs ~= 0 then
                    check = tbl.antiaim.fs ~= 1
                    tbl.antiaim.last = check
                    tbl.antiaim.current = check
                    tbl.antiaim.active = true
                end
                if ui.get(menutbl["method"]) == "simple" and tbl.antiaim.fs == 0 then
                    check = not tbl.antiaim.last
                    tbl.antiaim.current = check
                    tbl.antiaim.active = true
                end
                if ui.get(menutbl["method"]) == "luasense" then
                    if tbl.antiaim.count then
                        if tbl.antiaim.timer > ui.get(menutbl["timer"]) then
                            tbl.antiaim.timer = 0
                            tbl.antiaim.count = false
                            tbl.antiaim.log = {}
                        else
                            tbl.antiaim.timer = tbl.antiaim.timer + 1
                        end
                    end
					if tbl.antiaim.fs == 0 then
						if arg.command_number % 3 == 1 then
							tbl.antiaim.ready = true
						end
						if tbl.antiaim.ready and arg.chokedcommands == 0 then
							tbl.antiaim.ready = false
							tbl.antiaim.luasensefake = not tbl.antiaim.luasensefake
						end
						local yaw = tbl.antiaim.manual.aa
						check = tbl.antiaim.luasensefake
						if tbl.antiaim.luasensefake then
							ui.set(tbl.items.yaw[2], tbl.clamp(yaw + ui.get(menutbl["right"])))
						else
							ui.set(tbl.items.yaw[2], tbl.clamp(yaw + ui.get(menutbl["left"])))
						end
					end
                end
                if ui.get(menutbl["antibf"]) == "yes" then
                    if enemy ~= nil then
                        if tbl.antiaim.log[enemy] ~= nil then
                            check = tbl.antiaim.log[enemy]
                        end
                    end
                end
                ui.set(tbl.items.jitter[2], check and -3 or 3)
                ui.set(tbl.items.body[2], check and -123 or 123)
                if ui.get(menutbl["defensive"]) == "luasense" then
                    arg.force_defensive = arg.command_number % 3 ~= 1 or arg.weaponselect ~= 0 or arg.quick_stop == 1
                elseif ui.get(menutbl["defensive"]) == "always on" then
                    arg.force_defensive = true
                else end
            else end
            ui.set(tbl.items.edge[1], ui.get(menu["anti aimbot"]["keybinds"]["edge"]))
            local freestand = ui.get(menu["anti aimbot"]["keybinds"]["freestand"])
            local disablers = ui.get(menu["anti aimbot"]["keybinds"]["disablers"])
            if tbl.contains(disablers, "air") and (arg.in_jump == 1 or air) then
                freestand = false
            end
            if tbl.contains(disablers, "slow") and (ui.get(tbl.refs.slow[1]) and ui.get(tbl.refs.slow[2])) then
                freestand = false
            end
            if tbl.contains(disablers, "duck") and (duck) then
                freestand = false
            end
            if tbl.contains(disablers, "edge") and (ui.get(menu["anti aimbot"]["keybinds"]["edge"])) then
                freestand = false
            end
            if tbl.contains(disablers, "manual") and (tbl.antiaim.manual.aa ~= 0) then
                freestand = false
            end
            if tbl.contains(disablers, "fake lag") and (fakelag) then
                freestand = false
            end
            if tbl.antiaim.manual.aa ~= 0 then
                ui.set(tbl.items.base[1], "local view")
                if ui.get(menu["anti aimbot"]["keybinds"]["type_manual"]) ~= "default" then
                    ui.set(tbl.items.yaw[2], tbl.antiaim.manual.aa)
                    ui.set(tbl.items.jitter[1], "off")
                    ui.set(tbl.items.jitter[2], 0)
                    ui.set(tbl.items.body[1], ui.get(menu["anti aimbot"]["keybinds"]["type_manual"]) == "jitter" and "jitter" or "opposite")
                    ui.set(tbl.items.body[2], 0)
                end
            end
            if ui.get(menu["anti aimbot"]["keybinds"]["type_freestand"]) ~= "default" and freestand then
                ui.set(tbl.items.yaw[2], 0)
                ui.set(tbl.items.jitter[1], "off")
                ui.set(tbl.items.jitter[2], 0)
                ui.set(tbl.items.body[1], ui.get(menu["anti aimbot"]["keybinds"]["type_freestand"]) == "jitter" and "jitter" or "opposite")
                ui.set(tbl.items.body[2], 0)
                arg.force_defensive = true
            end
            ui.set(tbl.items.fs[1], freestand)
			local defensivecheck = (z.defensive.defensive > 3) and (z.defensive.defensive < 11)
            if fakelag or hideshot then
                defensivecheck = false
            end
			local defensivemenu = ui.get(menu["anti aimbot"]["features"]["defensive"])
			tbl.normal_aa = true
			tbl.tick_aa = tbl.tick_aa + 1
			tbl.list_aa[tbl.tick_aa] = {
				["aa"] = ui.get(tbl.items.yaw[2]),
			}
			if defensivemenu ~= "off" and defensivecheck and not freestand and tbl.antiaim.manual.aa == 0 and tbl.contains(ui.get(menu["anti aimbot"]["features"]["states"]), real_state) then
				tbl.normal_aa = false
				if defensivemenu == "pitch" then
					ui.set(tbl.items.pitch[1], "up")
                elseif defensivemenu == "spin" then
					ui.set(tbl.items.yaw[2], (((arg.command_number % 360) - 180) * 3) % 180)
				elseif defensivemenu == "random" then
					ui.set(tbl.items.yaw[2], client.random_int(-180,180))
				elseif defensivemenu == "random pitch" then
					ui.set(tbl.items.pitch[1], (arg.command_number % 4 > 2) and "up" or "down")
					ui.set(tbl.items.yaw[2], client.random_int(-180,180))
				elseif defensivemenu == "sideways up" then
					ui.set(tbl.items.pitch[1], "up")
					ui.set(tbl.items.yaw[2], (arg.command_number % 6 > 3) and 111 or -111)
				elseif defensivemenu == "sideways down" then
					ui.set(tbl.items.yaw[2], (arg.command_number % 6 > 3) and 111 or -111)
				end
				if defensivemenu ~= "pitch" then
					tbl.reset_aa = true
					tbl.defensive_aa = ui.get(tbl.items.yaw[2])
				end
			end
			tbl.list_aa[tbl.tick_aa]["check"] = tbl.normal_aa
			if tbl.normal_aa and tbl.reset_aa and ui.get(menu["anti aimbot"]["features"]["fixer"]) == "luasense" then
				tbl.reset_aa = false
				for i = 1, 69 do
					if tbl.list_aa[tbl.tick_aa-i] then
						if tbl.list_aa[tbl.tick_aa-i]["check"] then
							if tbl.defensive_aa ~= tbl.list_aa[tbl.tick_aa-i]["aa"] then
								ui.set(tbl.items.yaw[2], tbl.list_aa[tbl.tick_aa-i]["aa"])
								return nil
							end
						end
					end
				end
			end
        end,
        ["reset"] = function()
			if tbl.contains(ui.get(menu["visuals & misc"]["visuals"]["notify"]), "reset") then
				push_notify("Reset for new round!")
			end
            tbl.antiaim.manual.aa = 0
            tbl.antiaim.manual.tick = 0
            if ui.get(menu["visuals & misc"]["misc"]["autobuy"]) ~= "off" then
                client.exec("buy " .. (ui.get(menu["visuals & misc"]["misc"]["autobuy"]) == "scout" and "ssg08" or "awp"))
            end
        end,
		["menu"] = function()
            ui.set(menu["anti aimbot"]["keybinds"]["left"], "on hotkey")
            ui.set(menu["anti aimbot"]["keybinds"]["right"], "on hotkey")
            ui.set(menu["anti aimbot"]["keybinds"]["forward"], "on hotkey")
            ui.set(menu["anti aimbot"]["keybinds"]["backward"], "on hotkey")
            local tick = globals.tickcount()
            if ui.get(menu["anti aimbot"]["keybinds"]["left"]) and (tbl.antiaim.manual.tick < tick - 11) then
                tbl.antiaim.manual.aa = tbl.antiaim.manual.aa == -90 and 0 or -90
                tbl.antiaim.manual.tick = tick
            end
            if ui.get(menu["anti aimbot"]["keybinds"]["right"]) and (tbl.antiaim.manual.tick < tick - 11) then
                tbl.antiaim.manual.aa = tbl.antiaim.manual.aa == 90 and 0 or 90
                tbl.antiaim.manual.tick = tick
            end
            if ui.get(menu["anti aimbot"]["keybinds"]["forward"]) and (tbl.antiaim.manual.tick < tick - 11) then
                tbl.antiaim.manual.aa = tbl.antiaim.manual.aa == 180 and 0 or 180
                tbl.antiaim.manual.tick = tick
            end
            if ui.get(menu["anti aimbot"]["keybinds"]["backward"]) and (tbl.antiaim.manual.tick < tick - 11) then
                tbl.antiaim.manual.aa = tbl.antiaim.manual.aa == -1 and 0 or -1
                tbl.antiaim.manual.tick = tick
            end
            if tbl.contains(ui.get(menu["visuals & misc"]["misc"]["features"]), "fix hideshot") then
                ui.set(limitfl, (ui.get(tbl.refs.hide[1]) and ui.get(tbl.refs.hide[2])) and 1 or 14)
            end
            if tbl.contains(ui.get(menu["visuals & misc"]["misc"]["features"]), "legs spammer") then
                ui.set(legs, globals.tickcount() % ui.get(menu["visuals & misc"]["misc"]["spammer"]) == 0 and "never slide" or "always slide")
            end
			if not ui.is_menu_open() then return nil end
			for i, v in next, tbl.items do
				for index, value in next, v do
					ui.set_visible(value, false)
				end
			end
            local current = ui.get(category)
            local sub = ui.get(menu["anti aimbot"]["submenu"])
            local subextra = ui.get(menu["visuals & misc"]["submenu"])
            local fix = true
            for i, v in next, aa do
                local section = ui.get(menu["anti aimbot"]["builder"]["builder"]) == i
                for index, value in next, v do 
                    local selected = ui.get(menu["anti aimbot"]["builder"]["team"]) == index
                    for ii, vv in next, value do
                        if ii ~= "type" and ii ~= "button" then
                            local mode = ui.get(value["type"])
                            for iii, vvv in next, vv do
                                fix = true
                                if ii == "normal" then
                                    if iii == "jitter_slider" then
                                        fix = ui.get(vv["jitter"]) ~= "off"
                                    end
                                    if iii == "body_slider" then
                                        fix = ui.get(vv["body"]) ~= "off" and ui.get(vv["body"]) ~= "opposite" and ui.get(vv["body"]) ~= "luasense"
                                    end
                                    if iii == "custom_slider" then
                                        fix = ui.get(vv["body"]) == "luasense"
                                    end
                                    if iii == "yaw" then
                                        fix = tbl.contains(ui.get(vv["mode"]), iii)
                                    end
                                    if iii == "left" or iii == "right" or iii == "method" then
                                        fix = tbl.contains(ui.get(vv["mode"]), "left right")
                                    end
                                end
                                if ii == "luasense" then
                                    if iii == "yaw" then
                                        fix = tbl.contains(ui.get(vv["mode"]), iii)
                                    end
                                    if iii == "left" or iii == "right" then
                                        fix = tbl.contains(ui.get(vv["mode"]), "left right")
                                    end
                                end
                                if ii == "auto" then
                                    if iii == "timer" or iii == "left" or iii == "right" then
                                        fix = ui.get(vv["method"]) == "luasense"
                                    end
                                end
                                ui.set_visible(vvv, section and selected and current == "anti aimbot" and sub == "builder" and mode == ii and fix)
                            end
                        else
                            ui.set_visible(vv, section and selected and current == "anti aimbot" and sub == "builder")
                        end
                    end
                end
            end
            for i, v in next, menu do
                for index, value in next, v do
                    if i == "anti aimbot" and index ~= "submenu" then
                        for ii, vv in next, value do
                            fix = true
                            if index == "features" then
                                if ii == "distance" then
                                    fix = ui.get(value["backstab"]) ~= "off"
                                end
                                if ii == "fix" then
                                    fix = ui.get(value["legit"]) ~= "off"
                                end
								if ii == "fixer" or ii == "states" then
									fix = ui.get(value["defensive"]) ~= "off"
								end
                            end
                            if index == "keybinds" then
                                if ii == "edge" then
                                    fix = tbl.contains(ui.get(value["keys"]), ii)
                                end
                                if ii == "freestand" or ii == "type_freestand" or ii == "disablers" then
                                    fix = tbl.contains(ui.get(value["keys"]), "freestand")
                                end
                                if ii == "left" or ii == "right" or ii == "forward" or ii == "backward" or ii == "type_manual" then
                                    fix = tbl.contains(ui.get(value["keys"]), "manual")
                                end
                            end
                            ui.set_visible(vv, i == current and index == sub and fix)
                        end
                    elseif i == "visuals & misc" and index ~= "submenu" then
                        for ii, vv in next, value do
                            fix = true
                            if index == "misc" then
                                if ii == "spammer" then
                                    fix = tbl.contains(ui.get(value["features"]), "legs spammer")
                                end
                            end
                            if index == "visuals" then
                                if ii == "arrows_color" then
                                    fix = ui.get(value["arrows"]) ~= "-"
                                end
                            end
                            if index == "visuals" then
                                if ii == "indicators_color" then
                                    fix = ui.get(value["indicators"]) ~= "-"
                                end
                            end
                            ui.set_visible(vv, i == current and index == subextra and fix)
                        end
                    else
                        ui.set_visible(value, i == current)
                    end
                end
            end
		end,
        ["animations"] = function()
			local myself = entity.get_local_player()
            if tbl.contains(ui.get(menu["visuals & misc"]["misc"]["features"]), "animations") and myself ~= nil then
                entity.set_prop(myself, "m_flPoseParameter", 1, bit.band(entity.get_prop(myself, "m_fFlags"), 1) == 0 and 6 or 0)
            end
        end,
        ["arrows"] = function()
            local myself = entity.get_local_player()
            if myself ~= nil and entity.is_alive(myself) then
				local width, height = client.screen_size()
                local r2, g2, b2, a2 = 55,55,55,255
                local highlight_fraction =  (globals.realtime() / 2 % 1.2 * 2) - 1.2
                local output = ""
                local text_to_draw = " S E N S E"
                for idx = 1, #text_to_draw do
                    local character = text_to_draw:sub(idx, idx)
                    local character_fraction = idx / #text_to_draw
                    local r1, g1, b1, a1 = 255, 255, 255, 255
                    local highlight_delta = (character_fraction - highlight_fraction)
                    if highlight_delta >= 0 and highlight_delta <= 1.4 then
                        if highlight_delta > 0.7 then
                            highlight_delta = 1.4 - highlight_delta
                        end
                        local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r1, g2 - g1, b2 - b1
                        r1 = r1 + r_fraction * highlight_delta / 0.8
                        g1 = g1 + g_fraction * highlight_delta / 0.8
                        b1 = b1 + b_fraction * highlight_delta / 0.8
                    end
                    output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, 255, text_to_draw:sub(idx, idx))
                end
                output = "L U A" .. output
                if ui.get(menu["visuals & misc"]["visuals"]["watermark_spaces"]) == "yes" then
                    output = output:gsub(" ", "")
                end
                if getbuild() == "beta" then
                    output = output .. ("\a%x%x%x%x"):format(200, 69, 69, 255) .. " [BETA] "
                end
                local r,g,b = ui.get(menu["visuals & misc"]["visuals"]["watermark_color"])
                if ui.get(menu["visuals & misc"]["visuals"]["watermark"]) == "bottom" then
                    renderer.text(width/2, height - 20, r,g,b, 255, "c", 0, output)
                elseif ui.get(menu["visuals & misc"]["visuals"]["watermark"]) == "right" then
                    renderer.text(width - 69, height/2, r,g,b, 255, "c", 0, output)
                elseif ui.get(menu["visuals & misc"]["visuals"]["watermark"]) == "left" then
                    renderer.text(69, height/2, r,g,b, 255, "c", 0, output)
				end
                local r,g,b = ui.get(menu["visuals & misc"]["visuals"]["arrows_color"])
                local leftkey = ui.get(menu["visuals & misc"]["visuals"]["arrows"]) == "simple" and "<" or "⯇"
			    local rightkey = ui.get(menu["visuals & misc"]["visuals"]["arrows"]) == "simple" and ">" or "⯈"
                local w, h = client.screen_size()
                w, h = w/2, h/2
                local yaw_body = math.max(-60, math.min(60, math.floor((entity.get_prop(myself, "m_flPoseParameter", 11) or 0)*120-60+0.5)))
				if yaw_body > 0 and yaw_body > 60 then yaw_body = 60 end
				if yaw_body < 0 and yaw_body < -60 then yaw_body = -60 end
                local alpha = 255
                if ui.get(menu["visuals & misc"]["visuals"]["arrows"]) == "simple" then
                    renderer.text(w + 50, h, 111, 111, 111, 255, "c+", 0, rightkey)
                    if tbl.antiaim.manual.aa == 90 then
                        renderer.text(w + 50, h, r,g,b, alpha, "c+", 0, rightkey)
                    end
                    renderer.text(w - 50, h, 111, 111, 111, 255, "c+", 0, leftkey)
                    if tbl.antiaim.manual.aa == -90 then
                        renderer.text(w - 50, h, r,g,b, alpha, "c+", 0, leftkey)
                    end
                elseif ui.get(menu["visuals & misc"]["visuals"]["arrows"]) == "body" then
                    renderer.line(w + -(40), h-8, w + -(40), h+8, r, g, b, yaw_body > 0 and 55 or 255)
                    renderer.line(w + (42), h-8, w + (42), h+8, r, g, b, yaw_body < 0 and 55 or 255)
                    h = h - 2.5
                    renderer.text(w + 50, h, 111, 111, 111, 255, "c+", 0, rightkey)
                    if tbl.antiaim.manual.aa == 90 then
                        renderer.text(w + 50, h, r,g,b, alpha, "c+", 0, rightkey)
                    end
                    renderer.text(w - 50, h, 111, 111, 111, 255, "c+", 0, leftkey)
                    if tbl.antiaim.manual.aa == -90 then
                        renderer.text(w - 50, h, r,g,b, alpha, "c+", 0, leftkey)
                    end
                elseif ui.get(menu["visuals & misc"]["visuals"]["arrows"]) == "luasense" then
                    local xv, yv, zv = entity.get_prop(myself, "m_vecVelocity")
                    local speed = math.sqrt(xv*xv + yv*yv + zv*zv)/10
                    if tbl.antiaim.fs == 1 then
                        renderer.line(w + -(36+speed), h-8, w + -(36+speed), h+8, 255, 255, 255, alpha)
                    end
                    if tbl.antiaim.fs == -1 then
                        renderer.line(w + (38+speed), h-8, w + (38+speed), h+8, 255, 255, 255, alpha)
                    end
                    renderer.line(w + -(40+speed), h-8, w + -(40+speed), h+8, r, g, b, yaw_body > 0 and 55 or 255)
                    renderer.line(w + (42+speed), h-8, w + (42+speed), h+8, r, g, b, yaw_body < 0 and 55 or 255)
                    h = h - 2.5
                    renderer.text(w + (50+speed), h, 111, 111, 111, 255, "c+", 0, rightkey)
                    if tbl.antiaim.manual.aa == 90 then
                        renderer.text(w + (50+speed), h, r,g,b, alpha, "c+", 0, rightkey)
                    end
                    renderer.text(w - (50+speed), h, 111, 111, 111, 255, "c+", 0, leftkey)
                    if tbl.antiaim.manual.aa == -90 then
                        renderer.text(w - (50+speed), h, r,g,b, alpha, "c+", 0, leftkey)
                    end
                else end
            end
        end,
		["indicator"] = function()
			local myself = entity.get_local_player()
			if not entity.is_alive(myself) then return nil end
			if ui.get(menu["visuals & misc"]["visuals"]["indicators"]) == "default" then
				local w, h = client.screen_size()
				w, h = w/2, h/2
				local yaw_body = math.max(-60, math.min(60, math.floor((entity.get_prop(myself,"m_flPoseParameter", 11) or 0)*120-60+0.5)))
				if yaw_body > 0 and yaw_body > 60 then yaw_body = 60 end
				if yaw_body < 0 and yaw_body < -60 then yaw_body = -60 end
				scope_fix = entity.get_prop(myself, "m_bIsScoped") ~= 0
				if scope_fix then 
					if scope_int < 30 then
						scope_int = scope_int + 1
					end
				else
					if scope_int > 0 then
						scope_int = scope_int - 1
					end
				end
				w = w + scope_int
				w = w - 2
				local ind_height = 15
				local r, g, b = ui.get(menu["visuals & misc"]["visuals"]["indicators_color"])
				local r1, g1, b1, a1 = r,g,b, 255
				local r2, g2, b2, a2 = 155, 155, 155, 255
				if yaw_body > 0 then
					renderer.text( w, h + ind_height, 255, 255, 255, 255, "cb", nil, gradient(r2, g2, b2, a2, r1, g1, b1, a1, "luasense") )
				else
					renderer.text( w, h + ind_height, 255, 255, 255, 255, "cb", nil, gradient(r1, g1, b1, a1, r2, g2, b2, a2, "luasense") )
				end
				local dt_on = (ui.get(z.items.keys.dt[1]) and ui.get(z.items.keys.dt[2]))
				local hs_on = (ui.get(z.items.keys.hs[1]) and ui.get(z.items.keys.hs[2]))
				if ui.get(z.items.keys.fd[1]) then
					ind_height = ind_height + 8
					renderer.text( w, h + ind_height, r2, g2, b2, a2, "c-", nil, "DUCK" )
					if entity.get_prop(myself, "m_flDuckAmount") > 0.1 then
						if animkeys.duck < 255 then
							animkeys.duck = animkeys.duck + 2.5
						end
						renderer.text( w, h + ind_height, r1, g1, b1, animkeys.duck, "c-", nil, "DUCK" )
					else
						animkeys.duck = 0
					end
				else
					animkeys.duck = 0
				end
				if ui.get(z.items.keys.sp[1]) then
					ind_height = ind_height + 8
					if animkeys.safe  < 255 then
						animkeys.safe = animkeys.safe  + 2.5
					end
					renderer.text( w, h + ind_height, r1, g1, b1, animkeys.safe , "c-", nil, "SAFE" )
				else
					animkeys.safe = 0
				end
				if ui.get(z.items.keys.fb[1]) then
					ind_height = ind_height + 8
					if animkeys.baim  < 255 then
						animkeys.baim = animkeys.baim  + 2.5
					end
					renderer.text( w, h + ind_height, r1, g1, b1, animkeys.baim , "c-", nil, "BAIM" )
				else
					animkeys.baim = 0
				end
				if dt_on then
					ind_height = ind_height + 8
					renderer.text( w, h + ind_height, r2, g2, b2, a2, "c-", nil, "DT" )
					if (shift_int > 0) or (z.defensive.defensive > 1) then
						if animkeys.dt  < 255 then
							animkeys.dt  = animkeys.dt  + 2.5
						end
						renderer.text( w, h + ind_height, r1, g1, b1, animkeys.dt , "c-", nil, "DT" )
					else
						animkeys.dt = 0
					end
				else
					animkeys.dt = 0
				end
				if hs_on then
					ind_height = ind_height + 8
					renderer.text( w, h + ind_height, r2, g2, b2, a2, "c-", nil, "HS" )
					if not (dt_on) then
						if animkeys.hide  < 255 then
							animkeys.hide  = animkeys.hide  + 2.5
						end
						renderer.text( w, h + ind_height, r1, g1, b1, animkeys.hide , "c-", nil, "HS" )
					else
						animkeys.hide = 0
					end
				else
					animkeys.hide = 0
				end
				if ui.get(menu["anti aimbot"]["keybinds"]["freestand"]) then
					ind_height = ind_height + 8
					if animkeys.fs  < 255 then
						animkeys.fs = animkeys.fs  + 2.5
					end
					renderer.text( w, h + ind_height, r1, g1, b1, animkeys.fs , "c-", nil, "FS" )
				else
					animkeys.fs = 0
				end
			end
		end,
		["shutdown"] = function()
			for i, v in next, tbl.items do
				for index, value in next, v do
					ui.set_visible(value, true)
				end
			end
			ui.set(tbl.items.enabled[1], true)
			ui.set(tbl.items.base[1], "at targets")
			ui.set(tbl.items.pitch[1], "default")
			ui.set(tbl.items.yaw[1], "180")
			ui.set(tbl.items.yaw[2], 0)
			ui.set(tbl.items.jitter[1], "off")
			ui.set(tbl.items.jitter[2], 0)
			ui.set(tbl.items.body[1], "opposite")
			ui.set(tbl.items.body[2], 0)
			ui.set(tbl.items.fsbody[1], true)
			ui.set(tbl.items.edge[1], false)
			ui.set(tbl.items.fs[1], false)
			ui.set(tbl.items.fs[2], "always on")
			ui.set(tbl.items.roll[1], 0)
			ui.set_visible(tbl.items.jitter[2], false)
			ui.set_visible(tbl.items.body[2], false)
		end
	}
    tbl.events = {
        paint_ui = { "menu", "arrows", "indicator" },
        setup_command = { "command", "freestand" },
		shutdown = { "shutdown" },
        round_prestart = { "reset" },
        pre_render = { "animations" }
    }
    for index, value in next, tbl.events do 
        for i, v in next, value do client.set_event_callback(index, tbl.callbacks[v]) end
    end
end)({
    ref = function(a,b,c) return { ui.reference(a,b,c) } end,
    clamp = function(x) if x == nil then return 0 end x = (x % 360 + 360) % 360 return x > 180 and x - 360 or x end,
    contains = function(z,x) for i, v in next, z do if v == x then return true end end return false end,
    states = { "global", "standing", "moving", "air", "air duck", "duck", "duck moving", "slow motion", "fake lag", "hide shot" },
    getstate = function(air, duck, speed, slowcheck)
        local state = "global"
        if air and duck then state = "air duck" end
        if air and not duck then state = "air" end
        if duck and not air and speed < 1.1 then state = "duck" end
        if duck and not air and speed > 1.1 then state = "duck moving" end
        if speed < 1.1 and not air and not duck then state = "standing" end
        if speed > 1.1 and not air and not duck then state = "moving" end
		if slowcheck and not air and not duck and speed > 1.1 then state = "slow motion" end
        return state
    end
})