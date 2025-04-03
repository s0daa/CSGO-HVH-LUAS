-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
lib_error = function(library)
    error(string.format("Lavender - failed to retrieve '%s' library. Head over to ", library))
end

-- Libraries
local _A, csgo_weapons = pcall(require, "gamesense/csgo_weapons"); if not _A then lib_error("csgo_weapons") end
local _B, ease         = pcall(require, "gamesense/easing"); if not _B then lib_error("easing") end
local _C, anti_aim     = pcall(require, "gamesense/antiaim_funcs"); if not _C then lib_error("antiaim_funcs") end
local _D, trace        = pcall(require, "gamesense/trace"); if not _D then lib_error("trace") end
local _E, clipboard    = pcall(require, "gamesense/clipboard"); if not _E then lib_error("clipboard") end
local _F, http         = pcall(require, "gamesense/http"); if not _F then lib_error("http") end
local _H, images       = pcall(require, "gamesense/images"); if not _H then lib_error("images") end
local _I, base64       = pcall(require, "gamesense/base64"); if not _I then lib_error("base64") end
local _J, discord      = pcall(require, "gamesense/discord_webhooks"); if not _J then lib_error("discord_webhooks") end
local _K, ent          = pcall(require, "gamesense/entity"); if not _K then lib_error("entity") end
local vector           = require "vector"


-- Obex
local obex_data = obex_fetch and obex_fetch() or {username = "beazt", build = "debug", discord = "beazt"}
local username = obex_data.username:lower()
local build = obex_data.build:lower()
local version = "1.10"



-- Main
local lavender = {}

lavender.presets = { }

lavender.database = {
    configs = ":lavender::configs:",
    locations = ":lavender::locations:",
    last_config = ":lavender::last_config:"
}

lavender.ui = {
    aa = {        
        state = {},
        states = {},
    },
    config = {},
    rage = {},
    misc = {},
    visuals = {},
    current_tab ={},
    tab = {},
    tabs = {"HOME", "ANTI-AIM", "VISUALS", "MISC", "CONFIGS", "DEBUG"}
}

lavender.refs = {
    aa = {},
    fl = {},
    rage  = {},
    misc = {},
    visuals = {},
    settings = {},
    configs = {},
    lua = {}
}

lavender.antiaim = {
    states = {"global", "standing", "moving", "ducking", "air", "air duck", "slowwalk", "use"},
    state = "global"
}

lavender.locations = database.read(lavender.database.locations) or {}

lavender.locations.keybinds = lavender.locations.keybinds or vector(300, 400)
lavender.visuals = {
    keybinds = {
        bind_list  = { "Double tap", "On shot anti-aim", "Minimum damage", "Quick peek assist", "Force body aim", "Force safe point", "Fake duck", "Freestanding", "Ping spike" },
        ref_list = { {ui.reference("RAGE", "Aimbot", "Double tap")}, {ui.reference("AA", "Other", "On shot anti-aim")}, {select(1, ui.reference("RAGE", "Aimbot", "Minimum damage override"))}, {ui.reference("RAGE", "Other", "Quick peek assist")}, ui.reference("RAGE", "Aimbot", "Force body aim"), ui.reference("RAGE", "Aimbot", "force safe point"), ui.reference("RAGE", "Other", "duck peek assist"), {ui.reference("AA", "Anti-aimbot angles", "Freestanding")}, {ui.reference("MISC", "Miscellaneous", "Ping spike")} },
        pos  = lavender.locations.keybinds,
        dragging = false,
        in_drag = false,
        hovering = false,
        bind_mode  = { "always on", "holding", "toggled", "off hotkey" },
        width = 0,
        height = 23,
        opacity = 0,
        opacity_mode = 0,
        padding = 20,
        binds = {},
        title = "keybinds"
    },
    watermark = {
        padding = vector(40, 25),
        opacity = 0
    },
    panel = {
        padding = vector(23, 0),
        opacity = 0
    },
    velocity = {
        padding = vector(0, 0),
        opacity = 0
    }
}

local x_main, y_main = client.screen_size()


lavender.pos = {
    watermark = vector(client.screen_size() / 2, select(2, client.screen_size() / 2)),
    panel = vector(client.screen_size() / client.screen_size(), select(2, client.screen_size()) / 2),
    velocity = vector(x_main / 2, y_main / 4),
    min_dmg = vector(x_main / 2, y_main / 2),
    modern = vector(x_main / 2, y_main / 2)
}

lavender.handlers = {
    ui = {
        elements = {},
        config  = {}
    },
    aa = {
        state = {}
    },
    rage = {},
    visuals = {},
    misc = {}
}

local x, y = client.screen_size()

local center = vector(x/2,y/2)

local warning = images.get_panorama_image("icons/ui/warning.svg")

-- Skeet References

-- References

lavender.refs.aa.master                                            = ui.reference("AA", "Anti-aimbot angles", "Enabled")
lavender.refs.aa.yaw_base                                          = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
lavender.refs.aa.pitch                                             = ui.reference("AA", "Anti-aimbot angles", "Pitch")
lavender.refs.aa.yaw, lavender.refs.aa.yaw_offset                  = ui.reference("AA", "Anti-aimbot angles", "Yaw")
lavender.refs.aa.yaw_jitter, lavender.refs.aa.yaw_jitter_offset    = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
lavender.refs.aa.body_yaw, lavender.refs.aa.body_yaw_offset        = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
lavender.refs.aa.freestanding_body_yaw                             = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
lavender.refs.aa.edge_yaw                                          = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
lavender.refs.aa.freestanding, lavender.refs.aa.freestanding_key   = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
lavender.refs.aa.roll_offset                                       = ui.reference("AA", "Anti-aimbot angles", "Roll")
lavender.refs.fl.enable, lavender.refs.aa.enable_key               = ui.reference("AA", "Fake lag", "Enabled")
lavender.refs.fl.limit                                             = ui.reference("AA", "Fake lag", "Limit")
lavender.refs.fl.type                                              = ui.reference("AA", "Fake lag", "Amount")
lavender.refs.fl.variance                                          = ui.reference("AA", "Fake lag", "Variance")

lavender.refs.rage.double_tap, lavender.refs.rage.double_tap_key   = ui.reference("RAGE", "Aimbot", "Double tap")
lavender.refs.rage.minimum_damage                                  = ui.reference("RAGE", "Aimbot", "Minimum damage")
lavender.refs.rage.minimum_damage_override, lavender.refs.rage.md_key, lavender.refs.rage.md_slider = ui.reference("RAGE", "Aimbot", "Minimum damage override")
lavender.refs.rage.force_bodyaim                                   = ui.reference("RAGE", "Aimbot", "Force body aim")
lavender.refs.rage.prefer_bodyaim                                  = ui.reference("RAGE", "Aimbot", "Prefer body aim")
lavender.refs.rage.prefer_safepoint                                = ui.reference("RAGE", "Aimbot", "Prefer safe point")
lavender.refs.rage.force_safepoint                                 = ui.reference("RAGE", "Aimbot", "Force safe point")
lavender.refs.rage.quick_peek, lavender.refs.rage.quick_peek_key   = ui.reference("RAGE", "Other", "Quick peek assist")

lavender.refs.misc.hide_shots, lavender.refs.misc.hide_shots_key   = ui.reference("AA", "Other", "On shot anti-aim")
lavender.refs.misc.fakeducking                                     = ui.reference("RAGE", "Other", "Duck peek assist")
lavender.refs.misc.legs                                            = ui.reference("AA", "Other", "Leg movement")
lavender.refs.misc.slow_motion, lavender.refs.misc.slow_motion_key = ui.reference("AA", "Other", "Slow motion")
lavender.refs.misc.menu_color                                      = ui.reference("Misc", "Settings", "Menu color")
lavender.refs.misc.thirdperson, lavender.refs.misc.thirdperson_key = ui.reference("Visuals", "Effects", "Force third person (alive)")
lavender.refs.misc.clantag                                         = ui.reference("MISC", "Miscellaneous", "Clan tag spammer")
lavender.refs.ping_spike, lavender.refs.ping_spike_key             = ui.reference("MISC", "Miscellaneous", "Ping spike")

-- OOP Functions
local n = 0
local animation_time = 0
lavender.funcs = {

    aa = {
        reset = function(value)
            ui.set(lavender.refs.aa.master, value)
            ui.set(lavender.refs.aa.yaw_base, "Local view")
            ui.set(lavender.refs.aa.pitch, "Off")
            ui.set(lavender.refs.aa.yaw, "Off")
            ui.set(lavender.refs.aa.yaw_offset, 0)
            ui.set(lavender.refs.aa.yaw_jitter, "Off")
            ui.set(lavender.refs.aa.yaw_jitter_offset, 0)
            ui.set(lavender.refs.aa.body_yaw, "Off")
            ui.set(lavender.refs.aa.body_yaw_offset, 0)
            ui.set(lavender.refs.aa.freestanding_body_yaw, false)
            ui.set(lavender.refs.aa.freestanding, false)
            ui.set(lavender.refs.aa.edge_yaw, false)
            ui.set(lavender.refs.aa.roll_offset, 0)
        end,
        body_yaw_invert = function()
            return math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60))) > 0
        end,
        normalize_yaw = function(angle)
			angle =  angle % 360 
			angle = (angle + 360) % 360
			if (angle > 180)  then
				angle = angle - 360
			end
			return angle
		end,
        extend_vector = function(posx, posy, posz, length, angle)
            local rad = math.rad(angle)
            return posx + math.cos(rad) * length, posy + math.sin(rad)* length, posz
        end,
        freestanding_side = function(reversed_traces, dormant)

            if lavender.target == nil and not dormant then
                return nil
            end
        
            local me = entity.get_local_player()
        
            local lx, ly, lz = entity.get_origin(me)
            lz = lz + 64
        
            local ex, ey, ez
        
            if not dormant then
        
                ex, ey, ez = entity.get_origin(lavender.target)
                ez = ez + 64
        
            end
        
            local data = {left = 0, right = 0}
            local angles = {-45, -30, 30, 45}
            local _, yaw = client.camera_angles()
        
            for i, angle in ipairs(angles) do
                local damage = 0
                if dormant then
                    local headx, heady, headz = lavender.funcs.aa.extend_vector(lx, ly, lz, 8000, yaw + angle)
                    local fraction = client.trace_line(me, lx, ly, lz, headx, heady, headz)
                    data[angle > 0 and "right" or "left"] = data[angle > 0 and "right" or "left"] + fraction
                else
                    if not reversed_traces then
                        local headx, heady, headz = lavender.funcs.aa.extend_vector(lx, ly, lz, 200, lavender.target_angle + angle)
                        _, damage = client.trace_bullet(lavender.target, ex, ey, ez, headx, heady, headz, lavender.target)
                        data[angle > 0 and "right" or "left"] = data[angle > 0 and "right" or "left"] + damage
                    else
                        local headx, heady, headz = lavender.funcs.aa.extend_vector(ex, ey, ez, 200, lavender.target_angle - angle)
                        _, damage = client.trace_bullet(me, lx, ly, lz, headx, heady, headz, me)
                        data[angle < 0 and "right" or "left"] = data[angle > 0 and "right" or "left"] + damage
                    end
                end
            end
        
            if data.left > data.right then
                return 1
        
            elseif data.right > data.left then
                return 0
        
            else
               return 2
        
            end
        end
        },
    misc = {
        set_aa_visibility = function(visible)
            for k, v in pairs(lavender.refs.aa) do
                ui.set_visible(v, visible)
            end
        end,
		contains = function(t, v)
			for i, vv in pairs(t) do
				if vv == v then
					return true
				end
			end
			return false
		end,
        lerp = function(a, b, t)
            return a + (b - a) * t
        end,
        table_lerp = function(a, b, percentage)
            local result = {}
            for i=1, #a do
                result[i] = lavender.funcs.misc.lerp(a[i], b[i], percentage)
            end
            return result
        end,
        get_key_mode = function(ref)
            local key = { ui.get(ref) }
            local mode = key[2]
            
            if mode == nil then
                return "nil"
            end
            
            return lavender.visuals.keybinds.bind_mode[mode + 1]
        end,
        kb_get_max_width = function()
            local max = 0
        
            for name, bind in pairs(lavender.visuals.keybinds.binds) do
                local ref = type(bind.ref) == "table" and bind.ref[2] or bind.ref
                local state = ui.get(ref)
                local mode = lavender.funcs.misc.get_key_mode(ref)
                local name_w = lavender.funcs.renderer.measure_text("c", name).x
                local mode_w = lavender.funcs.renderer.measure_text("c", mode).x
        
                max = math.max(max, name_w + mode_w + lavender.visuals.keybinds.padding)
        
            end
        
            if max == 0 then
                max = lavender.funcs.renderer.measure_text("c", lavender.visuals.keybinds.title).x + lavender.visuals.keybinds.padding
            end
        
            return max
        end,
        inverse_lerp = function(a, b, weight)
            return (weight - a) / (b - a)
        end,
        split = function(string, sep)
            local result = {}
            for str in (string):gmatch("([^"..sep.."]+)") do
                table.insert(result, str)
            end
            return result
        end,
        colour_console = function(prefix, string)
            client.color_log(prefix[1], prefix[2], prefix[3], "lavender ~ \0")
            client.color_log(255, 255, 232, string)
        end
    },
    renderer = {
        measure_text = function(flags, ...)
            local args = {...}
            local string = table.concat(args, "")
        
            return vector(renderer.measure_text(flags, string))
        end,
        rgba_to_hex = function(r, g, b, a)
            return bit.tohex(
              (math.floor(r + 0.5) * 16777216) + 
              (math.floor(g + 0.5) * 65536) + 
              (math.floor(b + 0.5) * 256) + 
              (math.floor(a + 0.5))
            )
        end,
        gradient_text = function(r2, g2, b2, a2, text_to_draw, speed, base_r, base_g, base_b, base_a)
            local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
            local output = ""
            for idx = 1, #text_to_draw do
                local character = text_to_draw:sub(idx, idx)
                local character_fraction = idx / #text_to_draw
                
                local r, g, b, a = base_r, base_g, base_b, base_a
                local highlight_delta = math.abs(character_fraction - 0.5 - highlight_fraction) * 1
                if highlight_delta <= 1 then
                    local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r, g2 - g, b2 - b, a2 - a
                    r = r + r_fraction * (1 - highlight_delta)
                    g = g + g_fraction * (1 - highlight_delta)
                    b = b + b_fraction * (1 - highlight_delta)
                    a = a + a_fraction * (1 - highlight_delta)
                end
                output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, a, text_to_draw:sub(idx, idx))
            end
            return output
        end
        ,
        colour_text_menu = function(string_to_colour)
            local r, g, b, a = 185, 190, 255, 255
            return "\a" .. unpack({lavender.funcs.renderer.rgba_to_hex(r, g, b, a)}) .. string_to_colour
        end,
        colour_text = function(string_to_colour, accent)
            local r, g, b, a = ui.get(accent)
            return "\a" .. unpack({lavender.funcs.renderer.rgba_to_hex(r, g, b, a)}) .. string_to_colour .. "\aCDCDCDFF"
        end,
		rec = function(x, y, w, h, r, g, b, a, radius)
			radius = math.min(x/2, y/2, radius)
			renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
			renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
			renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
			renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
			renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
			renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
			renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
		end,

        rectangle_outline = function(x, y, w, h, r, g, b, a, thickness, radius)
            if thickness == nil or thickness < 1 then
              thickness = 1;
            end
        
            if radius == nil or radius < 0 then
              radius = 0;
            end
        
            local limit = math.min(w * 0.5, h * 0.5) * 0.5;
            thickness = math.min(limit / 0.5, thickness);
        
            local offset = 0;
        
            if radius >= thickness then
              radius = math.min(limit + (limit - thickness), radius);
              offset = radius + thickness;
            end
            if radius == 0 then
            renderer.rectangle(x + offset - 1, y, w - offset * 2 + 2, thickness, r, g, b, a);
            renderer.rectangle(x + offset - 1, y + h, w - offset * 2 + 2, -thickness, r, g, b, a);
            else
            renderer.rectangle(x + offset, y, w - offset * 2, thickness, r, g, b, a);
            renderer.rectangle(x + offset, y + h, w - offset * 2, -thickness, r, g, b, a);
            end
        
            local bounds = math.max(offset, thickness);
        
            renderer.rectangle(x, y + bounds, thickness, h - bounds * 2, r, g, b, a);
            renderer.rectangle(x + w, y + bounds, -thickness, h - bounds * 2, r, g, b, a);
        
            if radius == 0 then
              return
            end
        
            renderer.circle_outline(x + offset, y + offset, r, g, b, a, offset, 180, 0.25, thickness); -- ? left-top
            renderer.circle_outline(x + offset, y + h - offset, r, g, b, a, offset, 90, 0.25, thickness); -- ? left-botttom
        
            renderer.circle_outline(x + w - offset, y + offset, r, g, b, a, offset, 270, 0.25, thickness); -- ? right-top
            renderer.circle_outline(x + w - offset, y + h - offset, r, g, b, a, offset, 0, 0.25, thickness); -- ? right-bottom
        end,

		--glow_module = function(x, y, w, h, accent, width, rounding, accent_inner)
		--	local thickness = 1
		--	local offset = 1
		--	local r, g, b, a = accent:unpack()
		--	if accent_inner then
		--		m_render.rec(x , y, w, h, accent_inner, rounding)
		--		--renderer.blur(x , y, w, h)
		--		--m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
		--	end
		--	for k = 0, width do
		--		local accent = color(r, g, b, a * (k/width)^(2.3))
		--		m_render.rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h - (k - width - offset)*thickness*2, accent, rounding + thickness * (width - k + offset), thickness)
		--	end
		--end,
        rounded_rectangle = function(x, y, w, h, r, g, b, a, radius)
            y = y + radius
            local datacircle = {
                {x + radius, y, 180},
                {x + w - radius, y, 90},
                {x + radius, y + h - radius * 2, 270},
                {x + w - radius, y + h - radius * 2, 0},
            }
        
            local data = {
                {x + radius, y, w - radius * 2, h - radius * 2},
                {x + radius, y - radius, w - radius * 2, radius},
                {x + radius, y + h - radius * 2, w - radius * 2, radius},
                {x, y, radius, h - radius * 2},
                {x + w - radius, y, radius, h - radius * 2},
            }
        
            for _, data in pairs(datacircle) do
                renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
            end
        
            for _, data in pairs(data) do
               renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
            end
        end,
        glow_rectangle = function(x, y, w, h, r, g, b, a, round, size, g_w)
            for i = 1, size, 0.3 do
                local fixpositon = (i  - 1) * 2	 
                local fixi = i  - 1
                lavender.funcs.renderer.rounded_rectangle(x - fixi, y - fixi, w + fixpositon , h + fixpositon , r , g ,b , (a -  i * g_w) ,round)	
            end
        end,
        outline_glow = function(x, y, w, h, r, g, b, a, thickness, radius)
	    	if thickness == nil or thickness < 1 then
	    		thickness = 1;
	    	end
        
	    	if radius == nil or radius < 0 then
	    		radius = 0;
	    	end
        
	    	local limit = math.min(w * 0.5, h * 0.5);
        
	    	radius = math.min(limit, radius);
	    	thickness = thickness + radius;
        
	    	local rd = radius * 2;
	    	x, y, w, h = x + radius - 1, y + radius - 1, w - rd + 2, h - rd + 2;
        
	    	local factor = 1;
	    	local step = lavender.funcs.misc.inverse_lerp(radius, thickness, radius + 1);
        
	    	for k = radius, thickness do
	    	  local kd = k * 2;
	    	  local rounding = radius == 0 and radius or k;
            
	    	  lavender.funcs.renderer.rectangle_outline(x - k, y - k, w + kd, h + kd, r, g, b, a * factor / 3, 1, rounding);
	    	  factor = factor - step;
	    	end
	    end,
        fade_rounded_rect = function(x, y, w, h, radius, r, g, b, a, glow)
            local n = a == 0 and 0 or a / 15
            --renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, a)
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, 1)
            --renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, 270, 0.25, 1)
            renderer.gradient(x, y + radius, 1, 1+h - radius * 2, r, g, b, a, r, g, b, n, false)
            renderer.gradient(x + w - 1, y + radius - 1, 1, 1+h - radius * 2, r, g, b, n, r, g, b, a, false)
            --renderer.circle_outline(x + radius, y + h - radius, r, g, b, 155, radius, 90, 0.25, 1)
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, 1)
            renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
            if a > 45 then
	    	    lavender.funcs.renderer.outline_glow(x, y, w, h, r, g, b, glow, 5, radius)
            end
        end,
        fade_rounded_rect_notif = function(x, y, w, h, radius, r, g, b, a, glow, w1)
            local n = a / 15
            local w1 = w1 < 3 and 0 or w1
            local circ_fill = w1 > 5 and 0.25 or w1 / 150
            
            -- left
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, circ_fill, 1)
            -- right
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, circ_fill, 1)
            -- left
            renderer.gradient(x + radius - 2, y, w1, 1, r, g, b, a, r, g, b, n, true)
            -- right
            renderer.gradient(x + w - w1 - radius + 2, y + h - 1, w1, 1, r, g, b, n, r, g, b, a, true)

            -- left
            renderer.gradient(x + radius - 5, y + h / 2 - radius * 2 + 2, 1, w1 / 3.5, r, g, b, a, r, g, b, n, false)
            -- right
            renderer.gradient(x + w - 1, y - w1 / 3.5 - (radius - h ) + 1, 1, w1 / 3.5, r, g, b, n, r, g, b, a, false)

            if a > 45 then
                lavender.funcs.renderer.outline_glow(x, y, w, h, r, g, b, glow, 5, radius)
            end

        end,
        fade_rounded_rect_vel = function(x, y, w, h, radius, r, g, b, a, glow, w1)
            local n = a / 15
            local w1 = w1 < 3 and 0 or w1
            local circ_fill = w1 > 5 and 0.25 or w1 / 150
            
            -- left
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, circ_fill, 1)
            -- right
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, circ_fill, 1)

            -- left
            renderer.gradient(x + radius - 2, y, w1, 1, r, g, b, a, r, g, b, n, true)
            -- right
            renderer.gradient(x + w - w1 - radius + 2, y + h - 1, w1, 1, r, g, b, n, r, g, b, a, true)

            -- left
            renderer.gradient(x + radius - 5, y + h / 2 - radius - h / 2 + 10, 1, w1 / 3.5, r, g, b, a, r, g, b, n, false)
            -- right
            renderer.gradient(x + w - 1, y - w1 / 3.5 - (radius - h ) + 1, 1, w1 / 3.5, r, g, b, n, r, g, b, a, false)

            -- glow
            if a > 45 then
                lavender.funcs.renderer.outline_glow(x, y, w, h, r, g, b, glow, 5, radius)
            end
        end,

        horizontal_fade_glow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1)
            local n = a / 255 * n
            renderer.rectangle(x, y + radius, 1, h - radius * 2, r, g, b, a)
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, 1)
            renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, 1)
            renderer.gradient(x + radius, y, w / 3.5 - radius * 2, 1, r, g, b, a, 0, 0, 0, n / 0, true)
            renderer.gradient(x + radius, y + h - 1, w / 3.5 - radius * 2, 1, r, g, b, a, 0, 0, 0, n / 0, true)
            renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r1, g1, b1, n)
            renderer.rectangle(x + radius, y, w - radius * 2, 1, r1, g1, b1, n)
            renderer.circle_outline(x + w - radius, y + radius, r1, g1, b1, n, radius, -90, 0.25, 1)
            renderer.circle_outline(x + w - radius, y + h - radius, r1, g1, b1, n, radius, 0, 0.25, 1)
            renderer.rectangle(x + w - 1, y + radius, 1, h - radius * 2, r1, g1, b1, n)
	    	lavender.funcs.renderer.outline_glow(x, y, w, h, r, g, b, glow, 5, radius)
        end
    },
    ease = {
        in_out_quart = function(x)

            local sqt = x^2
            return sqt / (2 * (sqt - x) + 1);
        
        end
    }
}

-- Notify library

local notify = {
    notifications = {
        side = {},
        bottom = {}
    },
    max = {
        side = 11,
        bottom = 5
    }
}

notify.__index = notify

local warning = images.get_panorama_image("icons/ui/warning.svg")

local screen_size = function()
    return vector(client.screen_size())
end

notify.queue_bottom = function()
    if #notify.notifications.bottom <= notify.max.bottom then
        return 0
    end
    return #notify.notifications.bottom - notify.max.bottom
end

notify.queue_side = function()
    if #notify.notifications.side <= notify.max.side then
        return 0
    end
    return #notify.notifications.side - notify.max.side
end

notify.clear_bottom = function()
    for i=1, notify.queue_bottom() do
        table.remove(notify.notifications.bottom, #notify.notifications.bottom)
    end
end

notify.clear_side = function()
    for i=1, notify.queue_side() do
        table.remove(notify.notifications.side, #notify.notifications.side)
    end
end


notify.new_bottom = function(timeout, color, title, ...)
    table.insert(notify.notifications.bottom, {
        started = false,
        instance = setmetatable({
            ["active"]  = false,
            ["timeout"] = timeout,
            ["color"]   = { r = color[1], g = color[2], b = color[3], a = 0 },
            ["x"]       = screen_size().x/2,
            ["y"]       = screen_size().y,
            ["text"]    = {...},
            ["title"]   = title,
            ["type"]    = "bottom"
        }, notify)
    })
end

function notify:handler()

    local side_count = 0
    local side_visible_amount = 0

    for index, notification in pairs(notify.notifications.side) do
        if not notification.instance.active and notification.started then
            table.remove(notify.notifications.side, index)
        end
    end

    for i = 1, #notify.notifications.side do
        if notify.notifications.side[i].instance.active then
            side_visible_amount = side_visible_amount + 1
        end
    end

    for index, notification in pairs(notify.notifications.side) do

        if index > notify.max.side then
            goto skip
        end
        
        if notification.instance.active then
            notification.instance:render_side(side_count, side_visible_amount)
            side_count = side_count + 1
        end

        if not notification.started then
            notification.instance:start()
            notification.started = true
        end

    end

    local bottom_count = 0
    local bottom_visible_amount = 0

    for index, notification in pairs(notify.notifications.bottom) do
        if not notification.instance.active and notification.started then
            table.remove(notify.notifications.bottom, index)
        end
    end

    for i = 1, #notify.notifications.bottom do
        if notify.notifications.bottom[i].instance.active then
            bottom_visible_amount = bottom_visible_amount + 1
        end
    end

    for index, notification in pairs(notify.notifications.bottom) do

        if index > notify.max.bottom then
            goto skip
        end
        
        if notification.instance.active then
            notification.instance:render_bottom(bottom_count, bottom_visible_amount)
            bottom_count = bottom_count + 1
        end

        if not notification.started then
            notification.instance:start()
            notification.started = true
        end

    end

    ::skip::
end

function notify:start()
    self.active = true
    self.delay = globals.realtime() + self.timeout
end

function notify:width()

    local w = 0
    
    local title_width = lavender.funcs.renderer.measure_text("b", self.title).x
    local warning_x, warning_y = warning:measure(nil, 15)

    for _, line in pairs(self.text) do
        local line_width = lavender.funcs.renderer.measure_text("", line).x
        w = w + line_width + 3
    end

    return math.max(w, title_width + warning_x + 5)
end

function notify:render_text(x, y)
    local x_offset = 0
    local padding = 3

    for i, line in pairs(self.text) do
        if i % 2 ~= 0 then
            r, g, b = 225, 225, 232
        else
           r, g, b = self.color.r, self.color.g, self.color.b

        end
        renderer.text(x + x_offset, y, r, g, b, self.color.a, "", 0, line)
        x_offset = x_offset + lavender.funcs.renderer.measure_text("", line).x + padding
    end
end

function notify:render_bottom(index, visible_amount)
    local screen = screen_size()
    local x, y = self.x - 5, self.y - 20
    local padding = 10
    local w, h = self:width() + padding * 2 - 2, 5 + padding* 2
    local colour = {ui.get(lavender.ui.visuals.notification_accent)}

    if globals.realtime() < self.delay then
        self.y = ease.quad_in_out(0.4, self.y, (( screen.y - 5 ) - ( (visible_amount - index) * h*1.4 )) - self.y, 1)
        self.color.a = ease.quad_in(0.18, self.color.a, 255 - self.color.a, 1)
    else
        self.y = ease.quad_in(0.3, self.y, screen.y - self.y, 1)
        self.color.a = ease.quad_out(0.1, self.color.a, 0 - self.color.a, 1)

        if self.color.a <= 2 then
            self.active = false
        end
    end
    
    local progress = math.max(0, (self.delay - globals.realtime()) / self.timeout)
    local bar_width = (w-10) * progress

    local animate_w1 = progress * (w/2) >= h * 2 and h * 2 or progress * (w/2)

    local animate_glow_s = progress * 100

    lavender.funcs.renderer.rounded_rectangle(x - w/2, y, w, h, 19, 19, 19, self.color.a, 5)
    lavender.funcs.renderer.rectangle_outline(x - w/2, y, w, h, 32, 32, 32, self.color.a, 2, 3)
    lavender.funcs.renderer.fade_rounded_rect_notif(x - w/2 - 1, y, w + 2, h, 5, self.color.r, self.color.g, self.color.b, 255, animate_glow_s * 2, animate_w1)
    self:render_text(x - w/2 + padding, y + h/2 - lavender.funcs.renderer.measure_text("", table.concat(self.text, " ")).y/2)
end

-- Configs funcs

function get_config(name)
    local database = database.read(lavender.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    for i, v in pairs(lavender.presets) do
        if v.name == name then
            return {
                config = base64.decode(v.config),
                index = i
            }
        end
    end

    return false
end

function save_config(name)

    local db = database.read(lavender.database.configs) or {}
    local config = {}

    if name:match("[^%w]") ~= nil then
        return
    end

    for _, v in pairs(lavender.handlers.ui.config) do
        local val = ui.get(v)

        if type(val) == "table" then
            if #val > 0 then
                val = table.concat(val, "|")
            else
                val = nil
            end
        end

        table.insert(config, tostring(val))
    end

    local cfg = get_config(name)

    if not cfg then
        table.insert(db, { name = name, config = table.concat(config, ":") })
    else
        db[cfg.index].config = table.concat(config, ":")
    end

    database.write(lavender.database.configs, db)
end

function delete_config(name)
    local db = database.read(lavender.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    for i, v in pairs(lavender.presets) do
        if v.name == name then
            return false
        end
    end

    database.write(lavender.database.configs, db)
end

function get_config_list()
    local db = database.read(lavender.database.configs) or {}
    local config = {}
    local presets = lavender.presets

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(db) do
        table.insert(config, v.name)
    end

    return config
end

function config_tostring()
    local config = {}
    for _, v in pairs(lavender.handlers.ui.config) do
        local val = ui.get(v)
        if type(val) == "table" then
            if #val > 0 then
                val = table.concat(val, "|")
            else
                val = nil
            end
        end
        table.insert(config, tostring(val))
    end

    return table.concat(config, ":")
end

function load_settings(config)
    local type_from_string = function(input)
        if type(input) ~= "string" then return input end

        local value = input:lower()

        if value == "true" then
            return true
        elseif value == "false" then
            return false
        elseif tonumber(value) ~= nil then
            return tonumber(value)
        else
            return tostring(input)
        end
    end

    config = lavender.funcs.misc.split(config, ":")
    local i = 1

    for _, v in pairs(lavender.handlers.ui.config) do
        if string.find(config[i], "|") then
            local values = lavender.funcs.misc.split(config[i], "|")
            ui.set(v, values)
        else
            ui.set(v, type_from_string(config[i]))
        end
        i = i + 1
    end
end


function export_settings()
    local config = config_tostring()
    local encoded = base64.encode(config)
    clipboard.set(encoded)
end

function import_settings()

    local config = clipboard.get()
    local decoded = base64.decode(config)
    load_settings(decoded)
end

function load_config(name)
    local config = get_config(name)
    load_settings(config.config)

    database.write(lavender.database.last_config, name)
end


-- UI handler

local update = function()
    for k, v in pairs(lavender.handlers.ui.elements) do
        if type(v.condition) == "function" then
            ui.set_visible(v.element, v.condition())
        else
            ui.set_visible(v.element, v.condition)
        end
    end
end

lavender.handlers.ui.new = function(element, condition, config, callback)
    condition = condition or true
    config = config or false
    callback = callback or function() end

    table.insert(lavender.handlers.ui.elements, { element = element, condition = condition})

    if config then
        table.insert(lavender.handlers.ui.config, element)
    end

    ui.set_callback(element, function(value)
        update()
        callback(value)
    end)

    update()

    return element
end


-- Welcome Screen

function startup()
    -- Welcome screen
    local logo = {
    "                   --:=-+==++                      ",
    "                   -=:+.=-  +: *                   ",
    "                   =- *. =- =-.*.                  ",
    "               -+---  --.*---=%                    ",
    "               :+     +-*   ==.                    ",
    "              -+=    :%+   .+.                     ",
    "             +:.*-- :*=+  :==.                     ",
    "            =- .* :*=  # +:                        ",
    "            #  =:  #   #=+.                        ",
    "           .#. *   #-. # .                         ",
    "       :--+-+#*..+-.:=-*:                          ",
    "       # #.:+.++*   *+:.#                          ",
    "    --=.=- *   :*  +: :+.                          ",
    "    #   *.=-   # -+   +.                           ",
    "  .=#   *+#  :=+*- .:-+:                           ",
    "  =::+.*.**.+:  -*==.                              ",
    "  := .%: :#*   -+-:+:                              ",
    "   #  :+  #  :+. .=+=*                             ",
    " -+    *  * -=  =-  +:                             ",
    " #     -=:*++  =-   *.         Welcome to Lavender, " .. username,
    " :=-:==+%=  #==*   :+:         You have, " .. build .. " access.",
    "    -+  *: *. .*===+           version loaded: " .. version,
    "  +-*-   #.+   *.  #           Any questions or issues, Create a ticket via our Discord",
    " := .*   *=*  :+   *           discord.gg/antiaim  ",
    "  *  .* +: .*+=+  =-                               ",
    "  .* :+-*=  *. *.-#:                               ",
    "    ++=  .+-+  *=. *                               ",
    "    =**:   *=.+.  :=.=.                            ",
    "    *  .-==*-#:  .#+---                            ",
    "    .*.   :+  -=:#=  +.                            ",
    "      ==-::#   .#   :+                             ",
    "      :-=+++*   +: =-                              ",
    "      ==     +: .**.                               ",
    "       .==-...**:+=                                ",
    "           ::.  :##                                ",
    "                 .%+                               ",
    "                  -@=                              ",
    "                   =@+                             ",
    "                    -@#                            ",
    "                     :%%-                          ",
    "                      .*@*.                        ",
    "                        -%%=                       ",
    "                          =%%=                     ",
    "                            =#%+.                  ",
    "                              :*%*-                ",
    "                                 -*%+:             ",
    "                                    -*%*-.         ",
    "                                       :+#%+-.     ",
    "                                           -+#%#+-."
     
           
    }
    client.exec("clear")
    for _, line in pairs(logo) do
        client.color_log(185, 190, 255, line)
    end

    -- Prepare AA
    lavender.funcs.aa.reset(true)

end
startup()

lavender.current_state = lavender.current_state == nil and "DEFAULT" or lavender.current_state:upper()

lavender.ui.current_tab = "HOME"

lavender.ui.tab_visualize = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " "))

-- Animated Main Text
lavender.handlers.control_animation_main = function()
    if lavender.ui.current_tab == "ANTIAIM" then
        cur_tab = "anti-aim"

    elseif lavender.ui.current_tab == "MISC" then
        cur_tab = "miscellaneous"

    elseif lavender.ui.current_tab == "CONFIGS" then
        cur_tab = "configurations"
    else
        cur_tab = lavender.ui.current_tab:lower()
    end

    if not ui.is_menu_open() then
        return end
    local colour = {185, 190, 255}
    if lavender.ui.current_tab ~= "HOME" then
        ui.set(lavender.ui.tab_visualize, lavender.funcs.renderer.colour_text_menu("lavender ~ ") .. lavender.funcs.renderer.gradient_text(colour[1], colour[2], colour[3], 255, cur_tab, 2, 23, 23, 23, 0))
    else
        ui.set(lavender.ui.tab_visualize, lavender.funcs.renderer.colour_text_menu(string.format("lavender ~ %s", username)))
    end
end

-- Main UI Buttonns
-- b9beff
lavender.ui.tab.antiaim = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "› \aB9BEFFFFanti-aim\aCDCDCDFF ‹", function() end), function() return lavender.ui.current_tab == "HOME" end)
lavender.ui.tab.visuals = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "› \aB9BEFFFFvisuals\aCDCDCDFF ‹", function() end), function() return lavender.ui.current_tab == "HOME" end)
lavender.ui.tab.misc = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "› \aB9BEFFFFmisc\aCDCDCDFF ‹", function() end), function() return lavender.ui.current_tab == "HOME" end)
lavender.ui.tab.configs = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "› \aB9BEFFFFconfigs\aCDCDCDFF ‹", function() end), function() return lavender.ui.current_tab == "HOME" end)
--lavender.ui.tab.debug = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "› \aB9BEFFFFdebug\aCDCDCDFF ‹", function() end), function() return lavender.ui.current_tab == "HOME" end)
lavender.ui.tab.home = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "› \aB9BEFFFFreturn home\aCDCDCDFF ‹", function() end), function() return lavender.ui.current_tab ~= "HOME" end)


-- Button Controller

for i, v in pairs(lavender.ui.tab) do
    ui.set_callback(v, function()
        lavender.ui.current_tab = i:upper()
		update()
    end)
end


-- UI Elements

-- Anti Aim

--lavender.ui.aa.selection = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "›› \aB9BEFFFFanti aim selection", {"anti aim builder", "anti brute builder", "exploits"}), function() return lavender.ui.current_tab == "ANTIAIM" end)
lavender.ui.aa.selection = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "›› \aB9BEFFFFanti aim selection", {"state builder", "anti-bruteforce", "extra"}), function() return lavender.ui.current_tab == "ANTIAIM" end)

lavender.ui.aa.state = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFbuilder\aCDCDCDFF› player \aB9BEFFFFstate", lavender.antiaim.states), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "state builder" end)

for k, v in pairs(lavender.antiaim.states) do
    lavender.ui.aa.states[v] = {}

    if v ~= "global" then
        lavender.ui.aa.states[v].master = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFenable\aCDCDCDFF› " .. v, false), function()
             return ui.get(lavender.ui.aa.state) == v and lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "state builder"
        end, true)
    end

    local show = function() return ui.get(lavender.ui.aa.state) == v and lavender.ui.current_tab == "ANTIAIM" and (v == "global" and true or ui.get(lavender.ui.aa.states[v].master)) and ui.get(lavender.ui.aa.selection) == "state builder" end

    lavender.ui.aa.states[v].pitch                  = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› pitch", {"off", "default", "up", "down", "minimal", "random"}), function() return show() end, true)
    lavender.ui.aa.states[v].yaw_base               = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw \aB9BEFFFFbase", {"local view", "at targets"}), function() return show() end, true)
    lavender.ui.aa.states[v].yaw                    = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw", {"off", "180", "spin", "static", "180 z", "crosshair"}), function() return show() end, true)
    lavender.ui.aa.states[v].jitter_type            = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› jitter type", {"default", "delayed", "flick"}), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" end, true)
    lavender.ui.aa.states[v].yaw_jitter_speed       = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw jitter \aB9BEFFFFspeed", 2, 20, 2, true, "t"), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].jitter_type) == "delayed" end, true)
    lavender.ui.aa.states[v].flick_speed            = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw flick \aB9BEFFFFmultiplier", 1, 3, 1, true, "", 1, {[1] = "3x", [2] = "2x", [3] = "1x"}), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].jitter_type) == "flick" end, true)
 
    lavender.ui.aa.states[v].yaw_type               = lavender.handlers.ui.new(  ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw \aB9BEFFFFtype", {"static", "jitter"}), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].jitter_type) == "default" end, true)
    lavender.ui.aa.states[v].yaw_offset_left        = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw offset \aB9BEFFFFleft", -180, 180, 0, true, "°"), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].jitter_type) ~= "flick" and (ui.get(lavender.ui.aa.states[v].yaw_type) == "jitter" or ui.get(lavender.ui.aa.states[v].jitter_type) == "delayed") end, true)
    lavender.ui.aa.states[v].yaw_offset_right       = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw offset \aB9BEFFFFright", -180, 180, 0, true, "°"), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].jitter_type) ~= "flick" and (ui.get(lavender.ui.aa.states[v].yaw_type) == "jitter" or ui.get(lavender.ui.aa.states[v].jitter_type) == "delayed") end, true)
    lavender.ui.aa.states[v].yaw_offset_flick_right = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw offset flick\aB9BEFFFF right", -180, 180, 0, true, "°"), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].jitter_type) == "flick" end, true)
    lavender.ui.aa.states[v].yaw_offset_flick_left  = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw offset flick\aB9BEFFFF left", -180, 180, 0, true, "°"), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].jitter_type) == "flick" end, true)
 
    lavender.ui.aa.states[v].yaw_offset_base        = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw offset \aB9BEFFFFbase", -180, 180, 0, true, "°"), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].jitter_type) == "flick" end, true)
    lavender.ui.aa.states[v].yaw_offset_static      = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw offset \aB9BEFFFFstatic", -180, 180, 0, true, "°"), function() return show() and ui.get(lavender.ui.aa.states[v].yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].yaw_type) == "static" and ui.get(lavender.ui.aa.states[v].jitter_type) == "default" end, true)
     
    lavender.ui.aa.states[v].yaw_jitter             = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw \aB9BEFFFFjitter", {"off", "offset", "center", "random", "skitter"}), function() return show() and ui.get(lavender.ui.aa.states[v].jitter_type) ~= "delayed" end, true)
    lavender.ui.aa.states[v].yaw_jitter_d           = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› yaw \aB9BEFFFFjitter delayed", {"offset", "center"}), function() return show() and ui.get(lavender.ui.aa.states[v].jitter_type) == "delayed" end, true)
    lavender.ui.aa.states[v].yaw_jitter_offset      = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "\n" .. v .. " - yaw jitter", -180, 180, 0, true, "°"), function() return show() and (ui.get(lavender.ui.aa.states[v].yaw_jitter) ~= "off" or ui.get(lavender.ui.aa.states[v].yaw_jitter_d) == "center" or ui.get(lavender.ui.aa.states[v].yaw_jitter_d) == "offset") end, true)
    lavender.ui.aa.states[v].body_yaw               = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles",  "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› body \aB9BEFFFFyaw", {"off", "opposite", "jitter", "static"}), function() return show() and ui.get(lavender.ui.aa.states[v].jitter_type) ~= "delayed" end, true)
    lavender.ui.aa.states[v].body_yaw_offset        = lavender.handlers.ui.new  (ui.new_slider("AA", "Anti-aimbot angles", "\n" .. v .. " - body yaw offset", -180, 180, 0, true, "°"), function() return show() and ui.get(lavender.ui.aa.states[v].body_yaw) ~= "off" and ui.get(lavender.ui.aa.states[v].body_yaw) ~= "opposite" and ui.get(lavender.ui.aa.states[v].jitter_type) ~= "delayed" end, true)
    lavender.ui.aa.states[v].force_defensive        = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "‹\aB9BEFFFF" .. v ..  "\aCDCDCDFF› force \aB9BEFFFFdefensive"), function() return show() end)
end


-- Anti Brute builder

local stages = { "1", "2", "3" }
lavender.ui.aa.antibrute_master = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFanti brute\aCDCDCDFF› master"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "anti-bruteforce" end, true)
lavender.ui.aa.reset_conditions = lavender.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "‹\aB9BEFFFFanti brute\aCDCDCDFF› reset conditions", "timout", "headshot", "round start", "death"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "anti-bruteforce" and ui.get(lavender.ui.aa.antibrute_master) end, true)
lavender.ui.aa.reset_timer = lavender.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "›› \aB9BEFFFFtimeout", 1, 10, 5, true, "s"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "anti-bruteforce" and ui.get(lavender.ui.aa.antibrute_master) and lavender.funcs.misc.contains(ui.get(lavender.ui.aa.reset_conditions), "timout") end, true)
lavender.ui.aa.stage = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFanti brute\aCDCDCDFF› stage", stages), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "anti-bruteforce" and ui.get(lavender.ui.aa.antibrute_master) end)
lavender.ui.aa.preview_stage = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFanti brute\aCDCDCDFF› force stage", "none", "1", "2", "3"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "anti-bruteforce" and ui.get(lavender.ui.aa.antibrute_master) end, true)
lavender.ui.aa.antibrute_disablers = lavender.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "‹\aB9BEFFFFanti brute\aCDCDCDFF› disable on", "standing", "moving", "ducking", "air", "air duck", "slowwalk", "use"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "anti-bruteforce" and ui.get(lavender.ui.aa.antibrute_master) end, true)

local stage = {}

for i,v in pairs(stages) do
    stage[v] = {}
    stage[v].master = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFenable\aCDCDCDFF› stage \aB9BEFFFF" .. v), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "anti-bruteforce" and ui.get(lavender.ui.aa.antibrute_master) and ui.get(lavender.ui.aa.stage) == v end, true)
    local show = function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "anti-bruteforce" and ui.get(lavender.ui.aa.antibrute_master) and ui.get(lavender.ui.aa.stage) == v and ui.get(stage[v].master) end

    stage[v].pitch             = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› pitch", {"off", "default", "up", "down", "minimal", "random"}), function() return show() end, true)
    stage[v].yaw_base          = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› yaw \aB9BEFFFFbase", {"local view", "at targets"}), function() return show() end, true)
    stage[v].yaw               = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› yaw", {"off", "180", "spin", "static", "180 z", "crosshair"}), function() return show() end, true)
    
    stage[v].yaw_offset_type   = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› yaw \aB9BEFFFFtype", {"jitter"}), function() return show() and ui.get(stage[v].yaw) ~= "off" end, true)
    stage[v].yaw_offset_left   = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› yaw offset \aB9BEFFFFleft", -180, 180, 0, true, "°"), function() return show() and ui.get(stage[v].yaw) ~= "off" and ui.get(stage[v].yaw_offset_type) == "jitter" end, true)
    stage[v].yaw_offset_right  = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› yaw offset \aB9BEFFFFright", -180, 180, 0, true, "°"), function() return show() and ui.get(stage[v].yaw) ~= "off" and ui.get(stage[v].yaw_offset_type) == "jitter" end, true)
    

    stage[v].yaw_jitter        = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› yaw jitter \aB9BEFFFFtype", {"off", "offset", "center", "random", "skitter"}), function() return show() end, true)
    stage[v].yaw_jitter_offset = lavender.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› yaw \aB9BEFFFFjitter", -180, 180, 0, true, "°"), function() return show() and ui.get(stage[v].yaw_jitter) ~= "off" end, true)

    
    stage[v].body_yaw          = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› body \aB9BEFFFFyaw", {"off", "static", "jitter", "opposite"}), function() return show() end, true)
    stage[v].body_yaw_offset   = lavender.handlers.ui.new  (ui.new_slider("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› body yaw \aB9BEFFFFoffset", -180, 180, 0, true, "°"), function() return show() and ui.get(stage[v].body_yaw) ~= "off" and ui.get(stage[v].body_yaw) ~= "opposite" end, true)

   -- stage[v].freestanding_body_yaw = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFstage " .. v ..  "\aCDCDCDFF› Freestanding body yaw", false), function() return show() and ui.get(stage[v].body_yaw) ~= "Off" end, true)
end

-- Extra

lavender.ui.aa.manual_master = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFextra\aCDCDCDFF› force \aB9BEFFFFyaw"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" end)
lavender.ui.aa.manual_left = lavender.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFforce left", false), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" and ui.get(lavender.ui.aa.manual_master) end)
lavender.ui.aa.manual_right = lavender.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFforce right", false), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" and ui.get(lavender.ui.aa.manual_master) end)
lavender.ui.aa.manual_back = lavender.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFforce back", false), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" and ui.get(lavender.ui.aa.manual_master) end)
lavender.ui.aa.manual_forward = lavender.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFforce forward", false), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" and ui.get(lavender.ui.aa.manual_master) end)
lavender.ui.aa.manual_jitter = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFforce jitter"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" and ui.get(lavender.ui.aa.manual_master) end)

lavender.ui.aa.anti_backstab = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFextra\aCDCDCDFF› anti \aB9BEFFFFbackstab"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" end)

lavender.ui.aa.freestanding_disablers = lavender.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "‹\aB9BEFFFFextra\aCDCDCDFF› freestanding \aB9BEFFFFdisablers", "standing", "moving", "ducking", "air", "air duck", "slowwalk", "use"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" end)
lavender.ui.aa.freestanding_key = lavender.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFfreestanding key", false, 0), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" end)
lavender.ui.aa.freestanding_jitter = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFjitter"), function() return lavender.ui.current_tab == "ANTIAIM" and ui.get(lavender.ui.aa.selection) == "extra" end)

-- Visuals
--> Crosshair Indicators
lavender.ui.visuals.crosshair_indicator = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFvisuals\aCDCDCDFF› crosshair \aB9BEFFFFindicators", {"-", "default", "modern"}), function() return lavender.ui.current_tab == "VISUALS" end)
--> Colours for crosshair indicators
lavender.ui.visuals.main_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFmain accent"), function() return lavender.ui.current_tab == "VISUALS" and (ui.get(lavender.ui.visuals.crosshair_indicator) == "default" or ui.get(lavender.ui.visuals.crosshair_indicator) == "modern") end)
lavender.ui.visuals.main_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline main accent", 185, 190, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and (ui.get(lavender.ui.visuals.crosshair_indicator) == "default" or ui.get(lavender.ui.visuals.crosshair_indicator) == "modern") end)
lavender.ui.visuals.trail_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFtrail accent"), function() return lavender.ui.current_tab == "VISUALS" and ui.get(lavender.ui.visuals.crosshair_indicator) == "modern" end)
lavender.ui.visuals.trail_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline trail accent", 23, 23, 23, 0), function() return lavender.ui.current_tab == "VISUALS" and ui.get(lavender.ui.visuals.crosshair_indicator) == "modern" end)
lavender.ui.visuals.state_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFstate accent"), function() return lavender.ui.current_tab == "VISUALS" and ui.get(lavender.ui.visuals.crosshair_indicator) == "modern" end)
lavender.ui.visuals.state_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline state accent", 255, 255, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and ui.get(lavender.ui.visuals.crosshair_indicator) == "modern" end)
lavender.ui.visuals.keystate_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFkeystate accent"), function() return lavender.ui.current_tab == "VISUALS" and ui.get(lavender.ui.visuals.crosshair_indicator) == "modern" end)
lavender.ui.visuals.keystate_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline keystate accent", 255, 255, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and ui.get(lavender.ui.visuals.crosshair_indicator) == "modern" end)
--> Extra
lavender.ui.visuals.extra_visual = lavender.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "‹\aB9BEFFFFvisuals\aCDCDCDFF› extra \aB9BEFFFFindicators", "watermark", "keybind list", "debug panel", "velocity warning"), function() return lavender.ui.current_tab == "VISUALS" end)
lavender.ui.visuals.watermark_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFwatermark accent"), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "watermark") end)
lavender.ui.visuals.watermark_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline watermark accent", 185, 190, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "watermark") end)
lavender.ui.visuals.kb_sec_bar_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFkeybind bar accent"), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "keybind list") end)
lavender.ui.visuals.keybind_sec_bar_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline sec bar accent", 185, 190, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "keybind list") end)
lavender.ui.visuals.debug_panel_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFdebug panel accent"), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "debug panel") end)
lavender.ui.visuals.debug_panel_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline debug panel accent", 185, 190, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "debug panel") end)
lavender.ui.visuals.velocity_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFvelocity warning accent"), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "velocity warning") end)
lavender.ui.visuals.velocity_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline velocity warning accent", 185, 190, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "velocity warning") end)
lavender.ui.visuals.notification_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFnotification accent"), function() return lavender.ui.current_tab == "VISUALS" end)
lavender.ui.visuals.notification_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline notification accent", 185, 190, 255, 255), function() return lavender.ui.current_tab == "VISUALS" end)

--> informative
lavender.ui.visuals.informative_visual = lavender.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "‹\aB9BEFFFFvisuals\aCDCDCDFF› informative \aB9BEFFFFindicators", "min damage indicator", "shot log (notify)", "shot log (console)"), function() return lavender.ui.current_tab == "VISUALS" end)

lavender.ui.visuals.min_dmg_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFminimum damage accent"), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "min damage indicator") end)
lavender.ui.visuals.min_dmg_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline min dmg accent", 255, 255, 235, 255), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "min damage indicator") end)
lavender.ui.visuals.log_notify_hit_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFshot log hit (notify) accent"), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (notify)") end)
lavender.ui.visuals.log_notify_hit_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline shot log hit (notify) accent", 185, 190, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (notify)") end)
lavender.ui.visuals.log_notify_miss_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFshot log miss (notify) accent"), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (notify)") end)
lavender.ui.visuals.log_notify_miss_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline shot log miss (notify) accent", 185, 190, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (notify)") end)
lavender.ui.visuals.log_console_accent_lab = lavender.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " ›› \aB9BEFFFFshot log (console) accent"), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (console)") end)
lavender.ui.visuals.log_console_accent = lavender.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inline shot log (console) accent", 185, 190, 255, 255), function() return lavender.ui.current_tab == "VISUALS" and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (console)") end)
-- Misc
lavender.ui.misc.anim_breaker_master = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFmisc\aCDCDCDFF› anim \aB9BEFFFFbreakers"), function() return lavender.ui.current_tab == "MISC" end)
lavender.ui.misc.standing_anim_breaker = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "›› \aB9BEFFFFstanding anim", {"-", "fist bump"}), function() return lavender.ui.current_tab == "MISC" and ui.get(lavender.ui.misc.anim_breaker_master) and ui.get(lavender.ui.misc.force_anim_breaker) == "-" and unpack(ui.get(lavender.ui.misc.poo_anim_breaker)) == nil end)
lavender.ui.misc.moving_anim_breaker = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "›› \aB9BEFFFFmoving anim", {"-", "dislocated arm", "frozen"}), function() return lavender.ui.current_tab == "MISC" and ui.get(lavender.ui.misc.anim_breaker_master) and ui.get(lavender.ui.misc.force_anim_breaker) == "-" and unpack(ui.get(lavender.ui.misc.poo_anim_breaker)) == nil end)
lavender.ui.misc.air_anim_breaker = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "›› \aB9BEFFFFair anim", {"-", "dumb", "stiff duck"}), function() return lavender.ui.current_tab == "MISC" and ui.get(lavender.ui.misc.anim_breaker_master) and ui.get(lavender.ui.misc.force_anim_breaker) == "-" and unpack(ui.get(lavender.ui.misc.poo_anim_breaker)) == nil end)
lavender.ui.misc.force_anim_breaker = lavender.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "›› \aB9BEFFFFforce anim", {"-", "t-pose"}), function() return lavender.ui.current_tab == "MISC" and ui.get(lavender.ui.misc.anim_breaker_master) and unpack(ui.get(lavender.ui.misc.poo_anim_breaker)) == nil end)
lavender.ui.misc.poo_anim_breaker = lavender.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "›› \aB9BEFFFFbasic anim", "zero pitch landing", "leg breaker", "moon walk", "static in air"), function() return lavender.ui.current_tab == "MISC" and ui.get(lavender.ui.misc.anim_breaker_master) and ui.get(lavender.ui.misc.force_anim_breaker) == "-" end)


--> killsay
lavender.ui.misc.killsay = lavender.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "‹\aB9BEFFFFmisc\aCDCDCDFF› kill \aB9BEFFFFsay"), function() return lavender.ui.current_tab == "MISC" end)


-- > Configs
-- List
lavender.ui.config.list = lavender.handlers.ui.new(ui.new_listbox("AA", "Anti-aimbot angles", "configs", " "), function() return lavender.ui.current_tab == "CONFIGS" end)
-- Name
lavender.ui.config.name = lavender.handlers.ui.new(ui.new_textbox("AA", "Anti-aimbot angles", "config name", " "), function() return lavender.ui.current_tab == "CONFIGS" end)
-- Load
lavender.ui.config.load = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "›› \aB9BEFFFFload", function() end), function() return lavender.ui.current_tab == "CONFIGS" end)
-- Save
lavender.ui.config.save = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "›› \aB9BEFFFFsave", function() end), function() return lavender.ui.current_tab == "CONFIGS" end)
-- Delete
lavender.ui.config.delete = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "›› \aB9BEFFFFdelete", function() end), function() return lavender.ui.current_tab == "CONFIGS" end)
-- Import
lavender.ui.config.import = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "›› \aB9BEFFFFimport", function() end), function() return lavender.ui.current_tab == "CONFIGS" end)
-- Export
lavender.ui.config.export = lavender.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "›› \aB9BEFFFFexport", function() return end), function() return lavender.ui.current_tab == "CONFIGS" end)

-- Legit AA on Use

on_use = function(cmd)

    local in_use = cmd.in_use == 1
    local me = entity.get_local_player()
    
    if not me or not entity.is_alive(me) then 
        return 
    end

    local weapon_ent = entity.get_player_weapon(me)

    if weapon_ent == nil then 
        return 
    end

    local weapon = csgo_weapons(weapon_ent)

    if weapon == nil then 
        return 
    end

    local local_pos     = vector(entity.get_origin(me))
    local in_bombzone   = entity.get_prop(me, "m_bInBombZone") > 0
    local holding_bomb  = weapon.type == "c4"

    local bomb_table    = entity.get_all("CPlantedC4")
    local bomb_planted  = #bomb_table > 0
    local bomb_distance = 100

    if bomb_planted then
        local bomb_entity = bomb_table[#bomb_table]
        local bomb_pos = vector(entity.get_origin(bomb_entity))
        bomb_distance = local_pos:dist(bomb_pos)
    end

    local defusing = bomb_distance < 62 and entity.get_prop(me, "m_iTeamNum") == 3

    if in_bombzone and holding_bomb or defusing then return end


	local from = vector(client.eye_position())
	local to = from + vector():init_from_angles(client.camera_angles()) * 1024

	local ray = trace.line(from, to, { skip = me, mask = "MASK_SHOT" })

    if not ray or ray.fraction > 1 or not ray.entindex then return end


    local ray_ent = pcall(function() entity.get_classname(ray.entindex) end) and entity.get_classname(ray.entindex) or nil

    if not ray_ent or ray_ent == nil then return end

    if ray_ent ~= "CWorld" and ray_ent ~= "CFuncBrush" and ray_ent ~= "CCSPlayer" then return end

    if in_use then
        cmd.in_use = 0
        return true
    end
end

-- Get state

local ground_ticks = 0

lavender.handlers.aa.get_state = function(cmd)
    local me = entity.get_local_player()
    local flags = entity.get_prop(me, "m_fFlags")
    local vel1, vel2, vel3 = entity.get_prop(me, 'm_vecVelocity')
    local speed = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))
    local ducking       = cmd.in_duck == 1
    local air           = ground_ticks < 5
    local walking       = speed > 5
    local standing      = speed <= 5
    local slow_motion   = ui.get(lavender.refs.misc.slow_motion) and ui.get(lavender.refs.misc.slow_motion_key)
    local fakeducking   = ui.get(lavender.refs.misc.fakeducking)
    local use           = on_use(cmd)
   -- local fakelag       = not fakeducking and anti_aim.get_double_tap() == false and not ui.get(lavender.refs.rage.double_tap_key) and not ui.get(lavender.refs.misc.hide_shots_key)
    --local freestanding = ui.get(lavender.ui.aa.freestanding_key) and not contains(ui.get(lavender.ui.aa.freestanding_disablers), lavender.antiaim.state)
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)

    if use then
        state = "use"
    elseif air and not ducking then
        state = "air"
    elseif air and ducking then
        state = "air duck"
    elseif fakeducking or ducking then
        state = "ducking"
    elseif slow_motion then
        state = "slowwalk"
    elseif standing then
        state = "standing"
    elseif walking then
        state = "moving"
    end

    lavender.antiaim.state = state

    return state
end


-- Main Visuals

lavender.paint_fraction = 0
lavender.paint = {
    dt = 0,
    os = 0,
    fs = 0
}

modern_edit = 0

lavender.handlers.visuals.indicators = function()

    local ar, ag, ab, aa = ui.get(lavender.ui.visuals.main_accent)
    local me = entity.get_local_player()
    local state = lavender.antiaim.state

    
    if entity.is_alive(me) == false or ui.get(lavender.ui.visuals.crosshair_indicator) == "-" then
        return end

    local main_acc = {ui.get(lavender.ui.visuals.main_accent)}
    local state_acc = {ui.get(lavender.ui.visuals.state_accent)}
    local keystate_acc = {ui.get(lavender.ui.visuals.keystate_accent)}
    local trail_accent = {ui.get(lavender.ui.visuals.trail_accent)}

    local dt = ui.get(lavender.refs.rage.double_tap_key) and ui.get(lavender.refs.rage.double_tap)
    local os = ui.get(lavender.refs.misc.hide_shots) and ui.get(lavender.refs.misc.hide_shots_key)
    local fd = ui.get(lavender.refs.misc.fakeducking)
    local fs = ui.get(lavender.refs.aa.freestanding_key) and ui.get(lavender.refs.aa.freestanding)
    local scoping = entity.get_prop(me, "m_bIsScoped") == 1 and true or false

	if ui.get(lavender.ui.visuals.crosshair_indicator) == "modern" then
        modern_edit = ease.quad_in(0.2, modern_edit, (scoping and 30 or 0) - modern_edit, 1)

        local measure_title = vector(renderer.measure_text("-c", "LAVENDER"))
        local keystate_active = os and not dt and "OS" or dt and not fd and "DT" or fd and "FD" or ""

        renderer.text(lavender.pos.modern.x + modern_edit, lavender.pos.modern.y + 25, main_acc[1], main_acc[2], main_acc[3], main_acc[4], "-c", 0, lavender.funcs.renderer.gradient_text(main_acc[1], main_acc[2], main_acc[3], main_acc[4], "LAVENDER", 2.42, trail_accent[1], trail_accent[2], trail_accent[3], trail_accent[4]))
        renderer.text(lavender.pos.modern.x + modern_edit, lavender.pos.modern.y + 25 + measure_title.y, state_acc[1], state_acc[2], state_acc[3], 255, "-c", 0, state:upper())
        renderer.text(lavender.pos.modern.x + modern_edit, lavender.pos.modern.y + 25 + (measure_title.y * 2), keystate_acc[1], keystate_acc[2], keystate_acc[3], 255, "-c", 0, keystate_active)




	elseif ui.get(lavender.ui.visuals.crosshair_indicator) == "default" then
        local scoped = entity.get_prop(me, "m_bIsScoped") == 1
        if scoped then
            lavender.paint_fraction = math.max(lavender.paint_fraction - globals.frametime(),0)
        else
            lavender.paint_fraction = math.min(lavender.paint_fraction + globals.frametime(),0.5)
        end

        local fraction = lavender.funcs.ease.in_out_quart(lavender.paint_fraction*2)
        local space = renderer.measure_text("-", "  ")
        local w4 = renderer.measure_text("-", "DT")
        local w5 = renderer.measure_text("-", "OS")
        local w6 = renderer.measure_text("-", "FS")

        if dt or lavender.paint.dt ~= 0 or lavender.paint.was_dt then
            if dt then
                lavender.paint.dt = math.min(lavender.paint.dt + globals.frametime()*5,1)
            else
                lavender.paint.dt = math.max(lavender.paint.dt - globals.frametime()*5,0)
            end
            local str = "DT"
            local size = w4 + (space + w5) * lavender.funcs.ease.in_out_quart(lavender.paint.os) + (space + w6) * lavender.funcs.ease.in_out_quart(lavender.paint.fs) + space * lavender.funcs.ease.in_out_quart(lavender.paint.os) * lavender.funcs.ease.in_out_quart(lavender.paint.fs)
            renderer.text(x/2 - (size/2) * fraction, y/2 + 20 + 20 * lavender.funcs.ease.in_out_quart(lavender.paint.dt), 255, 255, 255, 255 * lavender.funcs.ease.in_out_quart(lavender.paint.dt), "-", 0, str)
        end
        if fs or lavender.paint.fs ~= 0 then
            if fs then
                lavender.paint.fs = math.min(lavender.paint.fs + globals.frametime()*5,1)
            else

                lavender.paint.fs = math.max(lavender.paint.fs - globals.frametime()*5,0)
            end
            local str = "FS"
            local size = w6 + (space + w4) * lavender.funcs.ease.in_out_quart(lavender.paint.dt) + (space + w5) * lavender.funcs.ease.in_out_quart(lavender.paint.os) + space * lavender.funcs.ease.in_out_quart(lavender.paint.dt) * lavender.funcs.ease.in_out_quart(lavender.paint.os)
            renderer.text(x/2 - (size/2) * fraction + (w4 + space) * lavender.funcs.ease.in_out_quart(lavender.paint.dt), y/2 + 20 + 20 * lavender.funcs.ease.in_out_quart(lavender.paint.fs), 255, 255, 255, 255 * lavender.funcs.ease.in_out_quart(lavender.paint.fs), "-", 0, str)
        end

        if os or lavender.paint.os ~= 0 then
            if os then
                lavender.paint.os = math.min(lavender.paint.os + globals.frametime() * 5,1)
            else

                lavender.paint.os = math.max(lavender.paint.os - globals.frametime() * 5,0)
            end
            local str = "OS"
            local size = w5 + (space + w6) * lavender.funcs.ease.in_out_quart(lavender.paint.fs) + (space + w4) * lavender.funcs.ease.in_out_quart(lavender.paint.dt) + space * lavender.funcs.ease.in_out_quart(lavender.paint.fs) * lavender.funcs.ease.in_out_quart(lavender.paint.dt)
            renderer.text(x/2 - (size/2) * fraction + (w4 + space)*lavender.funcs.ease.in_out_quart(lavender.paint.dt) + (space + w6) * lavender.funcs.ease.in_out_quart(lavender.paint.fs), y/2 + 20 + 20 * lavender.funcs.ease.in_out_quart(lavender.paint.os), 255, 255, 255, 255* lavender.funcs.ease.in_out_quart(lavender.paint.os), "-", 0, str)

        end

        local r, g, b, a = unpack(lavender.funcs.misc.table_lerp({255,255,255,255}, {ar, ag, ab, aa}, math.abs(math.sin(globals.curtime()/2))))

        local r2, g2, b2, a2 = unpack(lavender.funcs.misc.table_lerp({ar, ag, ab, aa}, {255,255,255,155}, math.abs(math.sin(globals.curtime()/2))))

        local w1 = renderer.measure_text("-", " LAVENDER ")

        local w2 = renderer.measure_text("-", string.upper(build))

        renderer.text(x/2 - ((w1 + w2)/2 * fraction), y/2 + 20, r, g, b, a, "-", 0, "LAVENDER ")

        renderer.text(x/2 - ((w1 + w2)/2 * fraction) + w1, y/2 + 20, r2, g2, b2, a2 , "-", 0, string.upper(build))

        local w3 = renderer.measure_text("-", string.upper(tostring(lavender.antiaim.state)))

        renderer.text(x/2 - (w3/2)*fraction, y/2 + 30, 255, 255, 255, 155, "-", 0, string.upper(tostring(lavender.antiaim.state)))

        lavender.was_scoped = scoped

	elseif ui.get(lavender.ui.visuals.crosshair_indicator) == "simple" then

	end

end

-- MANUAL AA ARROWS

-- KEYBINDS


--init bind list
for i, bind in ipairs(lavender.visuals.keybinds.bind_list) do
    lavender.visuals.keybinds.binds[bind] = {
        ["pos"] = vector(lavender.locations.keybinds),
        ["opacity"] = 0,
        ["opacity_mode"] = 0,
        ["ref"] = lavender.visuals.keybinds.ref_list[i]
    }
end

-- handle and render keybinds
lavender.handlers.visuals.keybinds = function()

    local text_col = { 225, 225, 232 }
    local bar_col = { ui.get(lavender.ui.visuals.keybind_sec_bar_accent) }
    local main_col = { 19, 19, 19 }
    local screen = vector(client.screen_size())
    local mouse = vector(ui.mouse_position())
    local mouse_down = client.key_state(0x01)
    local menu_open = ui.is_menu_open()
    local max_width = lavender.funcs.misc.kb_get_max_width()
    local check_keybinds = ui.get(lavender.refs.rage.double_tap_key) or ui.get(lavender.refs.misc.hide_shots_key) or ui.get(lavender.refs.rage.quick_peek_key) or ui.get(ui.reference("RAGE", "Aimbot", "Force body aim")) or ui.get(ui.reference("RAGE", "Aimbot", "Force safe point")) or ui.get(ui.reference("RAGE", "Other", "Duck peek assist")) or ui.get(lavender.refs.aa.freestanding_key) or ui.get(lavender.refs.ping_spike_key) or ui.get(lavender.refs.rage.md_key)
    local h = lavender.visuals.keybinds.height
    local padding = lavender.visuals.keybinds.padding
    --print(ui.get(lavender.refs.rage.minimum_damage_key))
    lavender.visuals.keybinds.hovering = mouse.x >= lavender.visuals.keybinds.pos.x - padding/2 and mouse.x <= lavender.visuals.keybinds.pos.x + lavender.visuals.keybinds.width + padding/2 and mouse.y >= lavender.visuals.keybinds.pos.y and mouse.y <= lavender.visuals.keybinds.pos.y + h

    lavender.visuals.keybinds.width = menu_open and ease.quad_in(0.2, lavender.visuals.keybinds.width, 130 - lavender.visuals.keybinds.width, 1) or ease.quad_in(0.2, lavender.visuals.keybinds.width, max_width - lavender.visuals.keybinds.width - 10, 1)

    --drag
    if lavender.visuals.keybinds.hovering then
        lavender.visuals.keybinds.dragging = mouse_down
    end

    if lavender.visuals.keybinds.dragging then
        if not lavender.visuals.keybinds.in_drag then
            lavender.locations.keybinds = vector(lavender.visuals.keybinds.pos.x - mouse.x, lavender.visuals.keybinds.pos.y - mouse.y)
            lavender.visuals.keybinds.in_drag = true
        end
    end
    
    if lavender.visuals.keybinds.dragging then
        lavender.visuals.keybinds.pos = vector(math.max(0, math.min(screen.x - lavender.visuals.keybinds.width, mouse.x + lavender.locations.keybinds.x)), math.max(0, math.min(screen.y - 20, mouse.y + lavender.locations.keybinds.y)))
    else
        lavender.visuals.keybinds.in_drag = false
    end

    --opacity
    if lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "keybind list") then
        if check_keybinds or menu_open then
            lavender.visuals.keybinds.opacity = ease.quad_in(0.4, lavender.visuals.keybinds.opacity, 255 - lavender.visuals.keybinds.opacity, 1)
        else
            lavender.visuals.keybinds.opacity = ease.quad_in(0.4, lavender.visuals.keybinds.opacity, 0 - lavender.visuals.keybinds.opacity, 1)
        end
    else
        lavender.visuals.keybinds.opacity = ease.quad_in(0.3, lavender.visuals.keybinds.opacity, 0 - lavender.visuals.keybinds.opacity, 1)
    end

    if lavender.visuals.keybinds.opacity < 10 then
        return end


    --render top
    lavender.funcs.renderer.rounded_rectangle(lavender.visuals.keybinds.pos.x - padding/2, lavender.visuals.keybinds.pos.y, lavender.visuals.keybinds.width + padding, h, main_col[1], main_col[2], main_col[3], lavender.visuals.keybinds.opacity, 5)
    lavender.funcs.renderer.rectangle_outline(lavender.visuals.keybinds.pos.x - padding/2, lavender.visuals.keybinds.pos.y, lavender.visuals.keybinds.width + padding, h, 32, 32, 32, lavender.visuals.keybinds.opacity, 2, 3)
    renderer.text(lavender.visuals.keybinds.pos.x + lavender.visuals.keybinds.width/2, lavender.visuals.keybinds.pos.y + h/2, 225, 225, 232, lavender.visuals.keybinds.opacity, "cb", 0, lavender.visuals.keybinds.title)
    lavender.funcs.renderer.fade_rounded_rect_notif(lavender.visuals.keybinds.pos.x - padding/2 - 1, lavender.visuals.keybinds.pos.y, lavender.visuals.keybinds.width + padding + 2, h, 5, bar_col[1], bar_col[2], bar_col[3], lavender.visuals.keybinds.opacity, 190, h * 2)

    --render binds
    local count = 0
    for name, bind in pairs(lavender.visuals.keybinds.binds) do
        local ref = type(bind.ref) == "table" and bind.ref[2] or bind.ref
        local state = menu_open and true or ui.get(ref)
        local mode = lavender.funcs.misc.get_key_mode(ref)

        if menu_open and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "keybind list") then
            bind.pos.x = lavender.visuals.keybinds.pos.x - (padding/2)
            bind.pos.y = lavender.visuals.keybinds.pos.y + h + (15 * count)
        else
            bind.pos.x = ease.quad_in(0.4, bind.pos.x, (lavender.visuals.keybinds.pos.x - (padding/2)) - bind.pos.x, 1)
            bind.pos.y = ease.quad_in(0.4, bind.pos.y, lavender.visuals.keybinds.pos.y + h + (15 * count) - bind.pos.y, 1)
        end


        if state and lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "keybind list") then
            bind.opacity = ease.quad_in(0.4, bind.opacity, 255 - bind.opacity, 1)
            bind.opacity_mode = ease.quad_in(0.4, bind.opacity_mode, 125 - bind.opacity_mode, 1)
        else
            bind.opacity = ease.quad_in(0.4, bind.opacity, 0 - bind.opacity, 1)
            bind.opacity_mode = ease.quad_in(0.4, bind.opacity_mode, 0 - bind.opacity_mode, 1)
        end

        if bind.opacity <= 20 then
            goto skip
        end

        count = count + 1

        local col = {226, 226, 226}
        
        renderer.text(bind.pos.x + lavender.funcs.renderer.measure_text("c", name).x/2 + 5, bind.pos.y + h/2, text_col[1], text_col[2], text_col[3], bind.opacity, "c", 0, name:lower())
        renderer.text(bind.pos.x + lavender.visuals.keybinds.width - lavender.funcs.renderer.measure_text("c", mode).x/2 + 15, bind.pos.y + h/2, col[1], col[2], col[3], bind.opacity_mode, "c", 0, mode)

        ::skip::
    end
end

-- Watermark
lavender.handlers.visuals.watermark = function()
    local padding = lavender.visuals.watermark.padding
    local colour = lavender.ui.visuals.watermark_accent
    local r, g, b = ui.get(colour)
    local hour, minute, second, mill = client.system_time()
    local hr, m, s = string.format("%02d", hour), string.format("%02d", minute), string.format("%02d", second)
    local string = "user - " .. lavender.funcs.renderer.colour_text(username, colour) .. " | build - " .. lavender.funcs.renderer.colour_text(build, colour) .. " | " .. lavender.funcs.renderer.colour_text(hr, colour) .. ":" .. lavender.funcs.renderer.colour_text(m, colour) .. ":" .. lavender.funcs.renderer.colour_text(s, colour)
    local measure_string = vector(renderer.measure_text("", string .. "   "))
    local h = 25
    local w = measure_string.x + 10
    lavender.visuals.watermark.opacity = ease.quad_in(0.3, lavender.visuals.watermark.opacity, (lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "watermark") and 255 or 0) - lavender.visuals.watermark.opacity, 1)

    if lavender.visuals.watermark.opacity < 10 then
        return end

    lavender.funcs.renderer.rounded_rectangle((lavender.pos.watermark.x * 2 - padding.x)     - w , lavender.pos.watermark.y + padding.y, w, h, 19, 19, 19, lavender.visuals.watermark.opacity, 5)
    lavender.funcs.renderer.rectangle_outline((lavender.pos.watermark.x * 2 - padding.x)     - w , lavender.pos.watermark.y + padding.y, w, h, 32, 32, 32, lavender.visuals.watermark.opacity, 2, 3)
    lavender.funcs.renderer.fade_rounded_rect_notif((lavender.pos.watermark.x * 2 - padding.x - 1) - w , lavender.pos.watermark.y + padding.y, w + 2, h, 5, r, g, b, lavender.visuals.watermark.opacity, 190, h * 2)

    if lavender.visuals.watermark.opacity > 95 then
        renderer.text((lavender.pos.watermark.x * 2 - measure_string.x) - padding.x, lavender.pos.watermark.y + padding.y + (measure_string.y / 2), 226, 226, 226, 255, "", 0, string)
    end

end

lavender.handlers.visuals.debug_panel = function()
    if entity.is_alive(entity.get_local_player()) == false then 
        return end
    local padding = lavender.visuals.panel.padding
    local colour = lavender.ui.visuals.debug_panel_accent
    local r, g, b = ui.get(colour)
    local h = 155
    local w = 25

    lavender.visuals.panel.opacity = ease.quad_in(0.3, lavender.visuals.panel.opacity, (lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "debug panel") and 255 or 0) - lavender.visuals.panel.opacity, 1)

    if lavender.visuals.panel.opacity < 10 then
        return end

    
    local text_padding = vector(10, 5) -- x and y padding for the text
    string_top = " debug " .. lavender.funcs.renderer.colour_text("panel", colour)
    measure_top_string = vector(renderer.measure_text("", string_top))

    local rect_w = measure_top_string.x + 2*w + 2*text_padding.x
    local rect_h = measure_top_string.y + 2*text_padding.y
    if h > rect_h then
        rect_h = h
    end
    
    -- Background
    local rect_x = padding.x + lavender.pos.panel.x
    local rect_y = lavender.pos.panel.y + padding.y
    local threat = entity.get_player_name(client.current_threat())
    lavender.funcs.renderer.rounded_rectangle(rect_x, rect_y, rect_w - 2, rect_h, 19, 19, 19, lavender.visuals.panel.opacity, 5)
    lavender.funcs.renderer.rectangle_outline(rect_x, rect_y, rect_w - 2, rect_h, 32, 32, 32, lavender.visuals.panel.opacity, 2, 3)
    lavender.funcs.renderer.fade_rounded_rect(rect_x - 1, rect_y, rect_w, rect_h, 5, r, g, b, lavender.visuals.panel.opacity, 190)
    if lavender.visuals.panel.opacity > 95 then
        local text_x = rect_x + text_padding.x + w
        local text_y = rect_y + text_padding.y
        renderer.text(text_x, text_y, 255, 255, 255, 255, "b", 0, string_top)
        -- String
        renderer.text(w / 2 + rect_w / 2 - text_x + 20, text_y + 25, 255, 255, 255, 100, "b", 0, "BUILD")
        renderer.text(w / 2 + rect_w / 2 - text_x + 20, text_y + 40, 255, 255, 255, 255, "", 0, lavender.funcs.renderer.colour_text(build:upper(), colour))
        renderer.text(w / 2 + rect_w / 2 - text_x + 75, text_y + 25, 255, 255, 255, 100, "b", 0, "VERSION")
        renderer.text(w / 2 + rect_w / 2 - text_x + 75, text_y + 40, 255, 255, 255, 255, "", 0, lavender.funcs.renderer.colour_text(version, colour))
        renderer.text(w / 2 + rect_w / 2 - text_x + 20, text_y + 65, 255, 255, 255, 100, "b", 0, "CURRENT TARGET")
        renderer.text(w / 2 + rect_w / 2 - text_x + 20, text_y + 80, 255, 255, 255, 255, "", text_x + w * 2, lavender.funcs.renderer.colour_text(threat:upper(), colour))
        renderer.text(w / 2 + rect_w / 2 - text_x + 20, text_y + 105, 255, 255, 255, 100, "b", 0, "ANTI-AIM STATE")
        renderer.text(w / 2 + rect_w / 2 - text_x + 20, text_y + 120, 255, 255, 255, 255, "", 0, lavender.funcs.renderer.colour_text(lavender.current_state, colour))
    end
end

lavender.handlers.visuals.velocity_warning = function()
    local me = entity.get_local_player()
    local vel_mod = entity.get_prop(me, "m_flVelocityModifier")
    local colour = lavender.ui.visuals.velocity_accent
    local r, g, b = ui.get(colour)

    local string_meas = vector(renderer.measure_text("c", "velocity warning"))

    if entity.is_alive(me) == false then
        return end

    if not lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.extra_visual), "velocity warning") then
        return end
    
    local warning_x, warning_y = warning:measure(nil, 15)
    local h = 45
    local w = string_meas.x + 5

    local padding = lavender.visuals.velocity.padding
    lavender.visuals.velocity.opacity = ease.quad_in_out(0.3, lavender.visuals.velocity.opacity, (vel_mod == 1 and 0 or 255) - lavender.visuals.velocity.opacity, 1)

    if lavender.visuals.velocity.opacity < 10 then
        return end

    -- right box
    lavender.funcs.renderer.rounded_rectangle(lavender.pos.velocity.x - w / 5 - (warning_x + 25), lavender.pos.velocity.y + h * 2, w + warning_x + 15, h, 19, 19, 19, lavender.visuals.velocity.opacity, 5)
    lavender.funcs.renderer.rectangle_outline(lavender.pos.velocity.x - w / 5 - (warning_x + 25), lavender.pos.velocity.y + h * 2, w + warning_x + 15, h, 32, 32, 32, lavender.visuals.velocity.opacity, 2, 3)
    lavender.funcs.renderer.fade_rounded_rect_vel(lavender.pos.velocity.x - w / 5 - (warning_x + 25), lavender.pos.velocity.y + h * 2, w + warning_x + 15, h, 5, r, g, b, lavender.visuals.velocity.opacity, vel_mod * 255, vel_mod * 100)
    renderer.text(lavender.pos.velocity.x + w / 3.5 , lavender.pos.velocity.y + h * 2 + string_meas.y * 1.1, 226, 226, 226, lavender.visuals.velocity.opacity, "c", 0, "velocity")
    renderer.text(lavender.pos.velocity.x + w / 3.5 , lavender.pos.velocity.y + h * 2 + string_meas.y * 2.5, 226, 226, 226, lavender.visuals.velocity.opacity, "c", 0, math.floor(vel_mod * 100) .. "%")
    warning:draw(lavender.pos.velocity.x - w / 2 + (warning_x - 35 / 2), lavender.pos.velocity.y + h * 2 + warning_x - 8, nil, 30, r, g, b, lavender.visuals.velocity.opacity)

end

lavender.handlers.visuals.min_dmg_indicator = function()

    local me = entity.get_local_player()

    local colour = {ui.get(lavender.ui.visuals.min_dmg_accent)}

    if entity.is_alive(me) == false or not lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "min damage indicator") then
        return end

    if lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "min damage indicator") and ui.get(lavender.refs.rage.md_key) and ui.get(lavender.refs.rage.minimum_damage_override) then
        renderer.text(lavender.pos.min_dmg.x + 20, lavender.pos.min_dmg.y - 30, colour[1], colour[2], colour[3], 255, "", 0, ui.get(lavender.refs.rage.md_slider))
    end


end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

client.set_event_callback("aim_hit", function(e)
	local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    if lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (notify)") then
        notify.new_bottom(2, {ui.get(lavender.ui.visuals.log_notify_hit_accent)}, "shot_log_hit", "", "lavender", "~ hit", entity.get_player_name(e.target), "for", e.damage, "in", hgroup)
    end

    if lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (console)") then
        lavender.funcs.misc.colour_console({ui.get(lavender.ui.visuals.log_console_accent)}, string.format("hit %s for %s in %s", entity.get_player_name(e.target), e.damage, hgroup))
    end
end)

client.set_event_callback("aim_miss", function(e)
	local hgroup = hitgroup_names[e.hitgroup + 1] or '?'

    if lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (notify)") then
        notify.new_bottom(2, {ui.get(lavender.ui.visuals.log_notify_miss_accent)}, "shot_log_miss", "", "lavender", "~ missed due to", e.reason, "(hc: " .. math.floor(e.hit_chance) .. ", aimed: " .. hgroup .. ")")
    end

    if lavender.funcs.misc.contains(ui.get(lavender.ui.visuals.informative_visual), "shot log (console)") then
        lavender.funcs.misc.colour_console({ui.get(lavender.ui.visuals.log_console_accent)}, string.format("missed due to %s (hc: %s, aimed: %s)", e.reason, math.floor(e.hit_chance), hgroup))
    end

end)

local killsay_hs = {
    "𝕪𝕦𝕠 𝕘𝕠𝕥 𝕙𝕖𝕒𝕕𝕖𝕕 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕪𝕠𝕦 𝕙𝕒𝕧𝕖 𝕟𝕠 𝕝𝕒𝕧𝕖𝕟𝕕𝕖𝕣",
    "𝕝𝕒𝕧𝕖𝕟𝕕𝕖𝕣 𝕥𝕠𝕠 𝕤𝕥𝕣𝕠𝕟𝕜 𝕗𝕠𝕣 𝕖𝕟𝕖𝕞𝕪",
    "𝕨𝕙𝕪 𝕞𝕚𝕤𝕤? 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕒𝕞 𝕦𝕤𝕖 𝕝𝕒𝕧𝕖𝕟𝕕𝕖𝕣",
    "𝕥𝕣𝕪 𝕙𝕚𝕥 𝕞𝕖 𝕙𝕖𝕒𝕕",
}

local killsay_baim = {
    "𝕌 𝕒ℝ𝔼 𝔸ℝ𝔼 𝕋ℝ𝕐 𝕎𝕀ℕℕ𝕀ℕ𝔾 𝕄𝔼? 𝕓𝕚𝕘 𝕡𝕣𝕠𝕓𝕝𝕖𝕞",
    "𝕪𝕠𝕦𝕣'𝕣𝕖 𝕒𝕣𝕖 𝕘𝕠𝕥 𝕕𝕖𝕒𝕕𝕖𝕕 𝕓𝕪 𝕝𝕒𝕧𝕖𝕟𝕕𝕖𝕣",
    "𝕚 𝕒𝕞 𝕦𝕤𝕖 𝕓𝕖𝕤𝕥 𝕒𝕟𝕥𝕚𝕒𝕚𝕞 𝕝𝕦𝕒",
    "𝕔𝕒𝕟𝕥 𝕙𝕚𝕥??? 𝕃𝔸𝕧𝕖𝕟𝕕𝕖𝕣 𝕝𝕦𝕒"
}

client.set_event_callback("player_hurt", function(e)
    if not ui.get(lavender.ui.misc.killsay) then
        return
    end

    local attacker = client.userid_to_entindex(e.attacker)
    local victim = client.userid_to_entindex(e.userid)

    if attacker ~= entity.get_local_player() or victim == entity.get_local_player() then
        return
    end

    if e.health > 0 then
        return end

    if e.hitgroup == 1 then
        current_killsay = killsay_hs[client.random_int(1, #killsay_hs)]
    else
        current_killsay = killsay_baim[client.random_int(1, #killsay_baim)]
    end

    client.exec(string.format("say %s", current_killsay))

end)

-- Anti-Aim

-- ANTI backstab

distance_knife = {}
distance_knife.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

lavender.handlers.aa.anti_backstab = function()
    if ui.get(lavender.ui.aa.anti_backstab) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = distance_knife.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 230 then
                ui.set(lavender.refs.aa.yaw_offset, 180)
                ui.set(lavender.refs.aa.pitch, "Off")
                ui.set(lavender.refs.aa.yaw_base, "At targets")
                return true
            end
        end
    end
    return false
end


-- Manual AA

local leftready = false
local rightready = false
local forwardready = false
local manual_mode = "back"
lavender.handlers.aa.manual_aa = function()
    if ui.get(lavender.ui.aa.manual_master) == false or lavender.handlers.aa.anti_backstab() then
        return 
    end
    if ui.get(lavender.ui.aa.manual_back) then
        manual_mode = "back"
    elseif ui.get(lavender.ui.aa.manual_left) and leftready then
        if manual_mode == "left" then
            manual_mode = "back"
        else
            manual_mode = "left"
        end
        leftready = false
    elseif ui.get(lavender.ui.aa.manual_right) and rightready then
        if manual_mode == "right" then
            manual_mode = "back"
        else
            manual_mode = "right"
        end
        rightready = false
    elseif ui.get(lavender.ui.aa.manual_forward) and forwardready then
        if manual_mode == "forward" then
            manual_mode = "back"
        else
            manual_mode = "forward"
        end
        forwardready = false
    end
    if ui.get(lavender.ui.aa.manual_left) == false then
        leftready = true
    end
    if ui.get(lavender.ui.aa.manual_right) == false then
        rightready = true
    end
    if ui.get(lavender.ui.aa.manual_forward) == false then
        forwardready = true
    end 
    if manual_mode == "back" then
        
    elseif manual_mode == "left" then
        ui.set(lavender.refs.aa.yaw_offset, -90)
        ui.set(lavender.refs.aa.yaw_base, "Local view")
    elseif manual_mode == "right" then
        ui.set(lavender.refs.aa.yaw_offset, 90)
        ui.set(lavender.refs.aa.yaw_base, "Local view")
    elseif manual_mode == "forward" then
        ui.set(lavender.refs.aa.yaw_offset, -180)
        ui.set(lavender.refs.aa.yaw_base, "Local view")
    end
    if manual_mode == "left" or manual_mode == "right" or manual_mode == "forward" then
        if ui.get(lavender.ui.aa.manual_jitter) then
        else
            ui.set(lavender.refs.aa.yaw_jitter, 'Off')
            ui.set(lavender.refs.aa.body_yaw, "Static")
        end
    end

end

lavender.handlers.aa.freestanding = function()
    local freestanding = ui.get(lavender.ui.aa.freestanding_key) and not lavender.funcs.misc.contains(ui.get(lavender.ui.aa.freestanding_disablers), lavender.antiaim.state)
    if ui.get(lavender.ui.aa.freestanding_jitter) == false and freestanding and ui.get(lavender.ui.aa.freestanding_key) then
        ui.set(lavender.refs.aa.yaw_jitter, 'Off')
        ui.set(lavender.refs.aa.body_yaw, "Static")
    else
    end
    ui.set(lavender.refs.aa.freestanding_key, freestanding and "Always on" or "On hotkey")
    ui.set(lavender.refs.aa.freestanding, freestanding and true or false)
end

local choked_tick = 0
local inversion = 0
local jitter_real = false
local ticked_speed = 0
local chokereversed = false
local tick_var = 0
local function chokerev(a, b)
    return chokereversed and a or b
end

client.set_event_callback("setup_command", function(cmd)

    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

    local side = bodyyaw >= 0 and false or true
    local state = lavender.antiaim.state
    local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
    if ui.get(lavender.ui.aa.states[state].flick_speed) == 1 then
        ticked_speed = 3
    elseif ui.get(lavender.ui.aa.states[state].flick_speed) == 2 then
        ticked_speed = 9
    elseif ui.get(lavender.ui.aa.states[state].flick_speed) == 3 then
        ticked_speed = 15
    end

    local tick = tickbase % ticked_speed == 0
    local invert_flick_get = (lavender.funcs.aa.freestanding_side(false, true) == 0) and 1 or 0
    local invert_flick = invert_flick_get == 1

    if globals.tickcount() - tick_var > 0 and cmd.chokedcommands == 0 then
        chokereversed = not chokereversed
        tick_var = globals.tickcount()
    end

    if state ~= "global" and not ui.get(lavender.ui.aa.states[state].master) then
        state = "global"
    end
        ui.set(lavender.refs.aa.pitch, ui.get(lavender.ui.aa.states[state].pitch))
        ui.set(lavender.refs.aa.yaw_base, ui.get(lavender.ui.aa.states[state].yaw_base))
        ui.set(lavender.refs.aa.yaw, ui.get(lavender.ui.aa.states[state].yaw))
        if ui.get(lavender.ui.aa.states[state].jitter_type) ~= "delayed" then
            ui.set(lavender.refs.aa.yaw_jitter, ui.get(lavender.ui.aa.states[state].yaw_jitter))
            ui.set(lavender.refs.aa.body_yaw, ui.get(lavender.ui.aa.states[state].body_yaw))
        end
    -- ~

    if ui.get(lavender.ui.aa.states[state].yaw_type) == "static" and (ui.get(lavender.ui.aa.states[state].jitter_type) ~= "delayed" or ui.get(lavender.ui.aa.states[state].jitter_type) ~= "flick") then
        ui.set(lavender.refs.aa.yaw_offset, ui.get(lavender.ui.aa.states[state].yaw_offset_static))
    elseif ui.get(lavender.ui.aa.states[state].yaw_type) == "jitter" and (ui.get(lavender.ui.aa.states[state].jitter_type) ~= "delayed" or ui.get(lavender.ui.aa.states[state].jitter_type) ~= "flick") then
        if cmd.chokedcommands == 0 then
            ui.set(lavender.refs.aa.yaw_offset, chokerev(ui.get(lavender.ui.aa.states[state].yaw_offset_left), ui.get(lavender.ui.aa.states[state].yaw_offset_right)))
        end
    end

    if ui.get(lavender.ui.aa.states[state].jitter_type) == "default" then
        ui.set(lavender.refs.aa.yaw_jitter_offset, ui.get(lavender.ui.aa.states[state].yaw_jitter_offset))
        ui.set(lavender.refs.aa.body_yaw_offset, ui.get(lavender.ui.aa.states[state].body_yaw_offset))
    elseif ui.get(lavender.ui.aa.states[state].jitter_type) == "flick" then
            if tick then
                cmd.force_defensive = true
                ui.set(lavender.refs.aa.yaw_offset, invert_flick and ui.get(lavender.ui.aa.states[state].yaw_offset_flick_left) or ui.get(lavender.ui.aa.states[state].yaw_offset_flick_right))
                --ui.set(lavender.refs.aa.yaw_jitter_offset, 0)
               -- ui.set(lavender.refs.aa.body_yaw, "Opposite")
            else
                ui.set(lavender.refs.aa.yaw_offset, ui.get(lavender.ui.aa.states[state].yaw_offset_base))
                ui.set(lavender.refs.aa.yaw_jitter_offset, ui.get(lavender.ui.aa.states[state].yaw_jitter_offset))
                ui.set(lavender.refs.aa.body_yaw_offset, ui.get(lavender.ui.aa.states[state].body_yaw_offset))
            end
    elseif ui.get(lavender.ui.aa.states[state].jitter_type) == "delayed" then
        if cmd.chokedcommands == 0 then
            local ticks = ui.get(lavender.ui.aa.states[state].yaw_jitter_speed) * 2

            inversion = cmd.command_number % ticks >= ticks / 2
        end

        jitter_real = inversion and ui.get(lavender.ui.aa.states[state].yaw_offset_left) or ui.get(lavender.ui.aa.states[state].yaw_offset_right)
        if ui.get(lavender.ui.aa.states[state].yaw_jitter_d) == "center" then
            ui.set(lavender.refs.aa.yaw_offset, jitter_real + lavender.funcs.aa.normalize_yaw(inversion and -ui.get(lavender.ui.aa.states[state].yaw_jitter_offset) or ui.get(lavender.ui.aa.states[state].yaw_jitter_offset)))
            ui.set(lavender.refs.aa.yaw_jitter, "Off")
            ui.set(lavender.refs.aa.body_yaw, "Static")
            if jitter_real + lavender.funcs.aa.normalize_yaw(inversion and ui.get(lavender.ui.aa.states[state].yaw_jitter_offset) or -ui.get(lavender.ui.aa.states[state].yaw_jitter_offset)) < 160 or jitter_real + lavender.funcs.aa.normalize_yaw(inversion and ui.get(lavender.ui.aa.states[state].yaw_jitter_offset) or -ui.get(lavender.ui.aa.states[state].yaw_jitter_offset)) > -160 then
                ui.set(lavender.refs.aa.body_yaw_offset, jitter_real + lavender.funcs.aa.normalize_yaw(inversion and -ui.get(lavender.ui.aa.states[state].yaw_jitter_offset) or ui.get(lavender.ui.aa.states[state].yaw_jitter_offset)))
            else
                ui.set(lavender.refs.aa.body_yaw_offset, invert_flick and 180 or -180)
            end
        elseif ui.get(lavender.ui.aa.states[state].yaw_jitter_d) == "offset" then
            ui.set(lavender.refs.aa.yaw_offset, jitter_real + lavender.funcs.aa.normalize_yaw(inversion and 0 or ui.get(lavender.ui.aa.states[state].yaw_jitter_offset)))
            ui.set(lavender.refs.aa.yaw_jitter, "Off")
            ui.set(lavender.refs.aa.body_yaw, "Static")
            if jitter_real + lavender.funcs.aa.normalize_yaw(inversion and 0 or ui.get(lavender.ui.aa.states[state].yaw_jitter_offset)) < 160 or jitter_real + lavender.funcs.aa.normalize_yaw(inversion and 0 or ui.get(lavender.ui.aa.states[state].yaw_jitter_offset)) > -160 then
                ui.set(lavender.refs.aa.body_yaw_offset, jitter_real + lavender.funcs.aa.normalize_yaw(inversion and -ui.get(lavender.ui.aa.states[state].yaw_jitter_offset) or ui.get(lavender.ui.aa.states[state].yaw_jitter_offset)))
            else
                ui.set(lavender.refs.aa.body_yaw_offset, invert_flick and 180 or -180)
            end
        end
    end

    cmd.force_defensive = ui.get(lavender.ui.aa.states[state].force_defensive)

end)


-- anti brute builder

local abstage = 0

-- Anti Brute reset

lavender.handlers.aa.death = function(e)
    if lavender.funcs.misc.contains(ui.get(lavender.ui.aa.reset_conditions), "death") and ui.get(lavender.ui.aa.antibrute_master) and abstage > 0 then
        if client.userid_to_entindex(e.userid) == entity.get_local_player() then
            bruteforce_reset = true
            bruteforce = false
            set_brute = false
            abstage = 0
            lastmiss = 0
            notify.new_bottom(2, {ui.get(lavender.ui.visuals.notification_accent)},"", "", "lavender", "~ anti brute reset", "death")
        end
    end
end

client.set_event_callback("player_death", lavender.handlers.aa.death)

lavender.handlers.aa.round_start = function()
    if lavender.funcs.misc.contains(ui.get(lavender.ui.aa.reset_conditions), "round start") and ui.get(lavender.ui.aa.antibrute_master) and abstage > 0 then
        bruteforce_reset = true
        bruteforce = false
        set_brute = false
        lastmiss = 0
        notify.new_bottom(2, {ui.get(lavender.ui.visuals.notification_accent)},"", "", "lavender", "~ anti brute reset", "round end")
        abstage = 0
    end
end

client.set_event_callback("round_prestart", lavender.handlers.aa.round_start)

lavender.handlers.aa.headshot = function(c)
    if lavender.funcs.misc.contains(ui.get(lavender.ui.aa.reset_conditions), "On headshot") and ui.get(lavender.ui.aa.antibrute_master) and abstage > 0 then
        local attacker = client.userid_to_entindex(c.attacker)
        local victim = client.userid_to_entindex(c.userid)
        local me = entity.get_local_player()
        if me == nil or attacker == nil or victim == nil then
            return end
        if attacker ~= me and victim == me then
            if c.hitgroup == 1 then
                bruteforce_reset = true
                bruteforce = false
                set_brute = false
                abstage = 0
                lastmiss = 0
                notify.new_bottom(2, {ui.get(lavender.ui.visuals.notification_accent)},"", "", "lavender", "~ anti brute reset", "headshot")
            end
        end
    end
end
client.set_event_callback("player_hurt", lavender.handlers.aa.headshot)


local bruteforce_reset = true
local shot_time = 0
local lastmiss = 0


local function GetClosestPoint(A, B, P)
    a_to_p = { P[1] - A[1], P[2] - A[2] }
    a_to_b = { B[1] - A[1], B[2] - A[2] }

    atb2 = a_to_b[1]^2 + a_to_b[2]^2

    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end


client.set_event_callback("bullet_impact", function(e)
    state = lavender.antiaim.state

    if lavender.funcs.misc.contains(ui.get(lavender.ui.aa.antibrute_disablers), lavender.antiaim.state) then 
        return 
    end

    if not entity.is_alive(entity.get_local_player()) then 
        return 
    end

    local ent = client.userid_to_entindex(e.userid)

    if ent ~= client.current_threat() then 
        return 
    end

    if entity.is_dormant(ent) or not entity.is_enemy(ent) then 
        return 
    end

    if ui.get(lavender.ui.aa.antibrute_master) == false then
        return
    end
    

    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")

    local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
    local closest = GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)

    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)

    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

    if bruteforce then return end

    if math.abs(delta_2d) <= 45 and globals.curtime() - lastmiss > 0.225 then
        bruteforce = true
        shot_time = globals.realtime()
        lastmiss = globals.curtime()
        abstage = abstage >= 3 and 0 or abstage + 1
        abstage = abstage == 0 and 1 or abstage
        notify.new_bottom(1, {ui.get(lavender.ui.visuals.notification_accent)},"", "lavender", "~ anti-brute activated due to shot stage:", tostring(abstage))
    end
end)

lavender.handlers.aa.anti_brute = function(cmd)
    if lavender.funcs.misc.contains(ui.get(lavender.ui.aa.antibrute_disablers), lavender.antiaim.state) then return end
    local timer = lavender.funcs.misc.contains(ui.get(lavender.ui.aa.reset_conditions), "timout") and ui.get(lavender.ui.aa.reset_timer) or 999
    if bruteforce then
        bruteforce_reset = false
        abstage = abstage == 0 and 1 or abstage
        set_brute = true
        bruteforce = false
    elseif shot_time + timer < globals.realtime() or bruteforce_reset then
        abstage = 0
        bruteforce = false
        bruteforce_reset = true
        set_brute = false
    end
    return shot_time
end



client.set_event_callback("setup_command", function(c)
    if lavender.funcs.misc.contains(ui.get(lavender.ui.aa.antibrute_disablers), lavender.antiaim.state) then return end

    if set_brute == false and ui.get(lavender.ui.aa.preview_stage) == "Off" then return end

    set_stage = ui.get(lavender.ui.aa.preview_stage) == "none" and tostring(abstage) or tostring(ui.get(lavender.ui.aa.preview_stage))

    if set_stage == "0" then
        return 
    end

    if ui.get(stage[set_stage].master) == false then
        return 
    end

    if lavender.antiaim.state == "Use" then
        return end

    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw >= 0 and true or false

    local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")

    ui.set(lavender.refs.aa.pitch, ui.get(stage[set_stage].pitch))
    ui.set(lavender.refs.aa.yaw_base, ui.get(stage[set_stage].yaw_base))
    ui.set(lavender.refs.aa.yaw, ui.get(stage[set_stage].yaw))
    ui.set(lavender.refs.aa.yaw_jitter, ui.get(stage[set_stage].yaw_jitter))
    if c.chokedcommands == 0 then
        ui.set(lavender.refs.aa.yaw_offset, side and ui.get(stage[set_stage].yaw_offset_left) or ui.get(stage[set_stage].yaw_offset_right))
    end
    

    ui.set(lavender.refs.aa.yaw_jitter_offset, ui.get(stage[set_stage].yaw_jitter_offset))


    ui.set(lavender.refs.aa.body_yaw, ui.get(stage[set_stage].body_yaw))

    ui.set(lavender.refs.aa.body_yaw_offset, ui.get(stage[set_stage].body_yaw_offset))
    
   -- ui.set(lavender.refs.aa.freestanding_body_yaw, ui.get(stage[set_stage].freestanding_body_yaw))
end)

-- misc

-- anim breakers


local g_t = 180

lavender.handlers.misc.anim_breakers = function()
    
    local local_player = ent.get_local_player()
    local me = entity.get_local_player()

    local flags = entity.get_prop(me, "m_fFlags")

    if local_player == nil then
        return end

    if entity.is_alive(me) == false then return end

    if not ui.get(lavender.ui.misc.anim_breaker_master) then
        return end
    
    if unpack(ui.get(lavender.ui.misc.poo_anim_breaker)) == nil then
        if ui.get(lavender.ui.misc.force_anim_breaker) == "-" then
            if ui.get(lavender.ui.misc.standing_anim_breaker) == "fist bump" and lavender.antiaim.state == "standing" then
                --standing fist bump
                local_player:get_anim_overlay(7).weight = 1
                local_player:get_anim_overlay(7).sequence = 185
            end
            if ui.get(lavender.ui.misc.moving_anim_breaker) == "dislocated arm" and lavender.antiaim.state == "moving" then
                 --moving fist broken arms
                local_player:get_anim_overlay(7).weight = 1
                local_player:get_anim_overlay(6).sequence = 185
                local_player:get_anim_overlay(7).cycle = 0.5
                local_player:get_anim_overlay(7).playback_rate = 1.5
            elseif ui.get(lavender.ui.misc.moving_anim_breaker) == "frozen" and lavender.antiaim.state == "moving" then
                local_player:get_anim_overlay(7).weight = 1
                local_player:get_anim_overlay(6).sequence = 5
                local_player:get_anim_overlay(8).weight = 1
                local_player:get_anim_overlay(7).sequence = 400
                local_player:get_anim_overlay(4).cycle = 5
            end

            if ui.get(lavender.ui.misc.air_anim_breaker) == "dumb" and lavender.antiaim.state == "air" or ui.get(lavender.ui.misc.air_anim_breaker) == "stiff duck" and lavender.antiaim.state == "air duck" then
                local_player:get_anim_overlay(6).weight = 1
                local_player:get_anim_overlay(6).sequence = 135
                local_player:get_anim_overlay(7).weight = 1
                local_player:get_anim_overlay(7).sequence = 100
            elseif ui.get(lavender.ui.misc.air_anim_breaker) == "stiff duck" and lavender.antiaim.state == "air" or ui.get(lavender.ui.misc.air_anim_breaker) == "stiff duck" and lavender.antiaim.state == "air duck" then
                local_player:get_anim_overlay(6).weight = 1
                local_player:get_anim_overlay(6).sequence = 30
                local_player:get_anim_overlay(7).weight = 1
                local_player:get_anim_overlay(7).sequence = 25
                local_player:get_anim_overlay(2).cycle = 1
            end

         end

        if ui.get(lavender.ui.misc.force_anim_breaker) == "t-pose" then
             --t pose
            local_player:get_anim_overlay(2).weight = 1
            local_player:get_anim_overlay(2).sequence = 11
        end
    end
    if lavender.funcs.misc.contains(ui.get(lavender.ui.misc.poo_anim_breaker), "zero pitch landing") then
        g_t = bit.band(flags, 1) == 1 and g_t + 1 or 0
    
        if g_t > 20 and g_t < 210 then
            entity.set_prop(me, "m_flPoseParameter", 0.5, 12)
        end
    end

    if lavender.funcs.misc.contains(ui.get(lavender.ui.misc.poo_anim_breaker), "static in air") then
        entity.set_prop(me, "m_flPoseParameter", 1, 6) 
    end

    if lavender.funcs.misc.contains(ui.get(lavender.ui.misc.poo_anim_breaker), "leg breaker") then
        ui.set(lavender.refs.misc.legs, math.random(1,2) == 1 and "Always slide" or "Never slide")
    end

    if lavender.funcs.misc.contains(ui.get(lavender.ui.misc.poo_anim_breaker), "moon walk") then
        entity.set_prop(me, "m_flPoseParameter", 0, 7) 
        ui.set(lavender.refs.misc.legs, "Never slide")
    end


end

-- Configs Controller UI

ui.update(lavender.ui.config.list, get_config_list())
ui.set_callback(lavender.ui.config.list, function(value)
    local name = ""

    local configs = get_config_list()

    name = configs[ui.get(value)+1] or ""
    ui.set(lavender.ui.config.name, name)

end)



-- CONFIG LOAD


ui.set_callback(lavender.ui.config.load, function()
    local name = ui.get(lavender.ui.config.name)
    if name == "" then return end

    local protected = function()
        load_config(name)
    end

    if pcall(protected) then
        notify.new_bottom(4, {ui.get(lavender.ui.visuals.notification_accent)}, "", "succesfully loaded:", name)

    else
        notify.new_bottom(4, {255, 30, 30}, "", "failed to load:", name)
    end
end)

-- CONFIG SAVE

ui.set_callback(lavender.ui.config.save, function()

    local name = ui.get(lavender.ui.config.name)
    if name == "" then return end

    if name:match("[^%w]") ~= nil then
        notify.new_bottom(4, {255, 30, 30}, "", "cannot save this config:", name, "as it contains", "invalid characters")
        return
    end

    local protected = function()
        save_config(name)
    end

    if pcall(protected) then
        ui.update(lavender.ui.config.list, get_config_list())
        notify.new_bottom(4, {ui.get(lavender.ui.visuals.notification_accent)}, "", "succesfully saved:", name)
    else
        notify.new_bottom(4, {255, 30, 30}, "", "failed to save:", name)
    end

end)

-- CONFIG DELETE

ui.set_callback(lavender.ui.config.delete, function()
    local name = ui.get(lavender.ui.config.name)
    if name == "" then return end

    if delete_config(name) == false then
        notify.new_bottom(4, {255, 30, 30}, "", "failed to delete:", name)
        ui.update(lavender.ui.config.list, get_config_list())
        return
    end
    
    local protected = function()
        delete_config(name)
    end

    if pcall(protected) then
        ui.update(lavender.ui.config.list, get_config_list())
        ui.set(lavender.ui.config.list, #lavender.presets + #database.read(lavender.database.configs) - #database.read(lavender.database.configs))
        ui.set(lavender.ui.config.name, #database.read(lavender.database.configs) == 0 and "" or get_config_list()[#lavender.presets + #database.read(lavender.database.configs) - #database.read(lavender.database.configs)+1])
        notify.new_bottom(4, {ui.get(lavender.ui.visuals.notification_accent)}, "", "succesfully deleted:", name)
    else
        notify.new_bottom(4, {255, 50, 50}, "", "failed to delete:", name)
    end

end)

-- CONFIG IMPORT

ui.set_callback(lavender.ui.config.import, function()
    local protected = function()
       import_settings()
    end

    if pcall(protected) then
        notify.new_bottom(4, {ui.get(lavender.ui.visuals.notification_accent)}, "", "succesfully imported", "the config")

    else
        notify.new_bottom(4, {ui.get(lavender.ui.visuals.notification_accent)}, "", "failed to import", "the config")

    end
end)

-- CONFIG EXPORT

ui.set_callback(lavender.ui.config.export, function()
    local protected = function()
        export_settings(name)
    end

    if pcall(protected) then
        notify.new_bottom(4, {ui.get(lavender.ui.visuals.notification_accent)}, "", "succesfully exported", "the config")

    else
        notify.new_bottom(4, {ui.get(lavender.ui.visuals.notification_accent)}, "", "failed to export", "the config")
    end
end)


-- Callbacks

client.set_event_callback("run_command", function(cmd)


end)

client.set_event_callback("pre_render", function()

    lavender.handlers.misc.anim_breakers()

end)

client.set_event_callback("setup_command", function(cmd)

    lavender.handlers.aa.anti_backstab()

    lavender.handlers.aa.manual_aa()

    lavender.handlers.aa.get_state(cmd)

    lavender.handlers.aa.freestanding()

    lavender.handlers.aa.anti_brute(cmd)

end)

client.set_event_callback("paint", function()
    
    lavender.handlers.visuals.indicators()

    lavender.handlers.visuals.keybinds()

    lavender.handlers.visuals.debug_panel()

    lavender.handlers.visuals.velocity_warning()

    lavender.handlers.visuals.min_dmg_indicator()

    lavender.current_state = abstage > 0 and string.format("ANTI BRUTE - ST: %s", abstage) or "BUILDER"

end)

client.set_event_callback("aim_miss", function()

   -- lavender.handlers.visuals.shot_log_miss_notify()


end)

client.set_event_callback("paint_ui", function()
    lavender.funcs.misc.set_aa_visibility(false)
    
    lavender.handlers.control_animation_main()

    notify:handler()
    
    lavender.handlers.visuals.watermark()

end)

client.set_event_callback("shutdown", function()

    lavender.funcs.misc.set_aa_visibility(true)
    -- Save keybind location on shutdown
    local locations = database.read(lavender.database.locations) or {}
    locations.keybinds = { x = lavender.visuals.keybinds.pos.x, y = lavender.visuals.keybinds.pos.y }
	database.write(lavender.database.locations, locations)
end)
notify.new_bottom(4, {ui.get(lavender.ui.visuals.notification_accent)}, "ON_LOAD", "welcome,", username, "to", "lavender")
