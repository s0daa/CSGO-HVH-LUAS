-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local ffi = require('ffi')
local vector = require('vector')

local pui = require('gamesense/pui')
local color = require('gamesense/color')
local base64 = require("gamesense/base64")
local inspect = require('gamesense/inspect')
local clipboard = require("gamesense/clipboard")

local entity2 = require("gamesense/entity")
local csgo_weapons = require("gamesense/csgo_weapons")
local antiaim_funcs = require("gamesense/antiaim_funcs")


local refs, refs2 do
    refs = {
        aa = {
            enabled = pui.reference("AA", "Anti-aimbot angles", "Enabled"),
            pitch = pui.reference("AA", "Anti-aimbot angles", "Pitch"),
            pitch_val = select(2, pui.reference("AA", "Anti-aimbot angles", "Pitch")),
            yaw_base = pui.reference("AA", "Anti-aimbot angles", "Yaw base"),
            yaw = pui.reference("AA", "Anti-aimbot angles", "Yaw"),
            yaw_val = select(2, pui.reference("AA", "Anti-aimbot angles", "Yaw")),
            jitter = pui.reference("AA", "Anti-aimbot angles", "Yaw jitter"),
            jitter_val = select(2, pui.reference("AA", "Anti-aimbot angles", "Yaw jitter")),
            body = pui.reference("AA", "Anti-aimbot angles", "Body yaw"),
            body_val = select(2, pui.reference("AA", "Anti-aimbot angles", "Body yaw")),
            body_fs = pui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
            fs = pui.reference("AA", "Anti-aimbot angles", "Freestanding"),
            edge = pui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
            roll = pui.reference("AA", "Anti-aimbot angles", "Roll")
        },
        fl = {
            limit = pui.reference("AA","Fake lag", "Limit"),
            variance = pui.reference("AA","Fake lag", "Variance"),
            amount = pui.reference("AA","Fake lag", "Amount"),
            enabled = pui.reference("AA","Fake lag", "Enabled")
        },
        other = {
            slow = pui.reference("AA", "Other", "Slow motion"),
            osaa = pui.reference("AA","Other", "On shot anti-aim"),
            legmovement = pui.reference("AA","Other", "Leg movement"),
            fakepeek = pui.reference("AA","Other", "Fake peek")
        }
    }

    refs2 = {
        aimbot = pui.reference("RAGE", "Aimbot", "Enabled"),
        dt = pui.reference("RAGE", "Aimbot", "Double tap"),
        color = pui.reference("MISC", "Settings", "Menu Color"),
        dmg = pui.reference("RAGE", "Aimbot", "Minimum damage"),
        mdmg = pui.reference("RAGE", "Aimbot", "Minimum damage Override"),
        mdmg2 = select(2, pui.reference("RAGE", "Aimbot", "Minimum damage Override")),
        hc = pui.reference("RAGE", "Aimbot", "Minimum hit chance"),
        baim = pui.reference("RAGE", "Aimbot", "Force body aim"),
        safe = pui.reference("RAGE", "Aimbot", "Force safe point"),
        dt_fl = pui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
        ping = pui.reference("Misc", "Miscellaneous", "Ping spike"),
        ping_val = select(2, pui.reference("Misc", "Miscellaneous", "Ping spike")),
        scope = pui.reference('VISUALS', 'Effects', 'Remove scope overlay'),
        zoom = pui.reference('MISC', 'Miscellaneous', 'Override zoom FOV'),
        fov = pui.reference('MISC', 'Miscellaneous', 'Override FOV'),
        log_spread = pui.reference("RAGE", "Other", "Log misses due to spread"),
        log_dealt = pui.reference("Misc", "Miscellaneous", "Log damage dealt"),
        dpi = pui.reference("Misc", "Settings", "DPI scale"),
        fd = pui.reference("RAGE", "Other", "Duck peek assist"),
        thirdperson = pui.reference('VISUALS', 'Effects', 'Force third person (alive)'),
        tag = pui.reference('MISC', 'Miscellaneous', 'Clan tag spammer'),
        weapon = pui.reference('Rage', 'Weapon type', 'Weapon type'),
        lp = pui.reference('VISUALS', 'Colored models', 'Local player'),
        lp2 = select(2, pui.reference('VISUALS', 'Colored models', 'Local player')),
    }
end

local condition_list do
    math.randomseed(globals.framecount() + globals.tickcount() + globals.realtime())
    pui.macros.r = '\aC8C8C8'
    pui.macros.ez = '\aafafff'
    condition_list = {"Default", "Standing", "Running", "Slowwalking", "Crouch", "Crouch Move", "Jumping", "Crouching Air", "Fake Lag", "Manual yaw", "Safe Head", "Dormant"}
end

local screen do
    screen = {}
    screen.size = vector(client.screen_size())
    screen.center = vector(client.screen_size()) * 0.5
end


-- screen.size = vector(3840, 2160)
-- screen.center = vector(3840, 2160) * 0.5

-- screen.size = vector(1920, 1080)
-- screen.center = vector(1920, 1080) * 0.5

local colors,hard= {}, {}
local height = vector(renderer.measure_text('d', '1')).y

local version do
    version = {}
    version[1] = "abyss"
end

local default do
    default = {
        viewmodel = {
            fov = cvar.viewmodel_fov:get_string(),
            x = cvar.viewmodel_offset_x:get_string(),
            y = cvar.viewmodel_offset_y:get_string(),
            z = cvar.viewmodel_offset_z:get_string()
        },
        dist = cvar.cam_idealdist:get_string()
    }
end

local utils do
    utils = {}

    utils.lerp = function(start, end_pos, time, ampl)
        if start == end_pos then return end_pos end
        ampl = ampl or 1/globals.frametime()
        local frametime = globals.frametime() * ampl
        time = time * frametime
        local val = start + (end_pos - start) * time
        if(math.abs(val - end_pos) < 0.25) then return end_pos end
        return val 
    end

    utils.to_hex = function(color, cut)
        return string.format("%02X%02X%02X".. (cut and '' or "%02X"), color.r, color.g, color.b, color.a or 255)
    end

    utils.to_rgb = function(hex)
        hex = hex:gsub("^#", "")
        return color(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16) or 255)
    end

    utils.printc = function(text)
        local result = {}

        for color, content in text:gmatch("\a([A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9])([^%z\a]*)") do
            table.insert(result, {color, content})
        end
        local len = #result
        for i, t in pairs(result) do
            c = utils.to_rgb(t[1])
            client.color_log(c.r, c.g, c.b, t[2], len ~= i and '\0' or '')
        end
    end

    utils.normalize_yaw = function(x)
        return ((x + 180) % 360) - 180
    end
    
    utils.sine_yaw = function(tick, min, max)
        local amplitude = (max - min) / 2
        local center = (max + min) / 2
        return center + amplitude * math.sin(tick * 0.05)
    end
    
    utils.shuffle_table = function(t)
        for i = #t, 2, -1 do
            local j = math.random(i)
            t[i], t[j] = t[j], t[i]
        end
    end

    utils.rectangle = function(x, y, w, h, r, g, b, a, radius)
        radius = math.min(radius, w / 2, h / 2)

        local radius_2 = radius * 2

        renderer.rectangle(x + radius, y, w - radius_2, h, r, g, b, a)
        renderer.rectangle(x, y + radius, radius, h - radius_2, r, g, b, a)
        renderer.rectangle(x + w - radius, y + radius, radius, h - radius_2, r, g, b, a)

        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 270, 0.25)
        renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25)
    end

    utils.rectangle_outline = function(x, y, w, h, r, g, b, a)
        renderer.line(x, y, x + w, y, r, g, b, a)  -- Верхняя линия
        renderer.line(x + w, y, x + w, y + h, r, g, b, a)  -- Правая линия
        renderer.line(x + w, y + h, x, y + h, r, g, b, a)  -- Нижняя линия
        renderer.line(x, y + h, x, y, r, g, b, a)  -- Левая линия
    end
end

local db do
    db = {}
    local key = 'Rinnegan::db'
    db.db = database.read(key)

    db.save = function()
        database.write(key, db.db)
            client.delay_call(0, function()
            database.flush()
        end)
    end

    do
        if not db.db then
            db.db = {
                configs = {
                    ['Local'] = {},
                }
            }
        end

        if not db.db.last then
            db.db.last = {
                on = false,
                cfg = nil
            }
        end

        if not db.db.data then
            db.db.data = {
                time = 0,
                loaded = 1,
                killed = 0,
            }
        end 
        db.db.data.loaded = db.db.data.loaded + 1
        db.db.data.killed = db.db.data.killed or 0

        db.loaded = globals.realtime()
        client.set_event_callback('aim_hit', function(e)
            local health = entity.get_prop(e.target, 'm_iHealth')
            if health <= 0 then
                db.db.data.killed = db.db.data.killed + 1
            end
        end)

        local saving = function() end
        saving = function()
            db.db.data.time = db.db.data.time + (globals.realtime() - db.loaded)
            db.save()
            client.delay_call(300, saving)
        end saving()

        defer(function()
            db.db.data.time = db.db.data.time + (globals.realtime() - db.loaded)
            db.save()
        end)
        
    end
    db.icons = {"f1pp", "Cat 1", "Cat 2", "Dog", "Clown"}
    
    local default_cfg = 'eyJBbnRpYWltcyI6eyJidWlsZGVyIjp7IkNyb3VjaCI6eyJib2R5Ijp7InNpZGUiOjAsInlhdyI6IkppdHRlciIsImRlbGF5Ijp7InJpZ2h0IjoxLCJsZWZ0IjoxLCJkZWxheSI6MywibW9kZSI6IlN0YXRpYyIsInN3aXRjaCI6MH19LCJlbmFibGVkIjp0cnVlLCJqaXR0ZXIiOnsidmFsdWUyIjoxMywidmFsdWUiOjAsInR5cGUiOiJPZmZzZXQiLCJ3YXlzIjpbMCwwLDAsMCwwXSwibW9kZSI6IlNwaW4iLCJyYW5kIjo0fSwieWF3Ijp7ImJhc2UiOiJBdCB0YXJnZXRzIiwibGVmdCI6LTI2LCJnbG9iYWwiOjAsInJpZ2h0Ijo0OX0sImRlZmVuc2l2ZSI6eyJmb3JjZSI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwib3ZlcnJpZGUiOnRydWUsInNldHRpbmdzIjp7InBpdGNoX3NwZWVkIjoxMCwicGl0Y2hfdmFsIjotMjEsInBpdGNoIjoiQ3VzdG9tIiwiZGlzYWJsZXJzIjpbIn4iXSwieWF3X3ZhbCI6MCwieWF3X3NwZWVkIjoxMCwieWF3IjoiU3BpbiIsImR1cmF0aW9uIjoxM319fSwiQ3JvdWNoaW5nIEFpciI6eyJib2R5Ijp7InNpZGUiOjAsInlhdyI6IkppdHRlciIsImRlbGF5Ijp7InJpZ2h0IjoxLCJsZWZ0Ijo0LCJkZWxheSI6MSwibW9kZSI6IlN3aXRjaCIsInN3aXRjaCI6NH19LCJlbmFibGVkIjp0cnVlLCJqaXR0ZXIiOnsidmFsdWUyIjozLCJ2YWx1ZSI6LTE1LCJ0eXBlIjoiT2Zmc2V0Iiwid2F5cyI6WzAsMCwwLDAsMF0sIm1vZGUiOiJTcGluIiwicmFuZCI6NX0sInlhdyI6eyJiYXNlIjoiQXQgdGFyZ2V0cyIsImxlZnQiOi0xNywiZ2xvYmFsIjowLCJyaWdodCI6NDN9LCJkZWZlbnNpdmUiOnsiZm9yY2UiOnRydWUsImVuYWJsZWQiOnRydWUsIm92ZXJyaWRlIjp0cnVlLCJzZXR0aW5ncyI6eyJwaXRjaF9zcGVlZCI6MTAsInBpdGNoX3ZhbCI6MTMsInBpdGNoIjoiQ3VzdG9tIiwiZGlzYWJsZXJzIjpbIn4iXSwieWF3X3ZhbCI6MCwieWF3X3NwZWVkIjoxMCwieWF3IjoiUHJvZ3Jlc3NpdmUiLCJkdXJhdGlvbiI6MTF9fX0sIkNyb3VjaCBNb3ZlIjp7ImJvZHkiOnsic2lkZSI6MCwieWF3IjoiSml0dGVyIiwiZGVsYXkiOnsicmlnaHQiOjMsImxlZnQiOjIsImRlbGF5IjoyLCJtb2RlIjoiU3dpdGNoIiwic3dpdGNoIjozfX0sImVuYWJsZWQiOnRydWUsImppdHRlciI6eyJ2YWx1ZTIiOjAsInZhbHVlIjotMTUsInR5cGUiOiJSYW5kb20iLCJ3YXlzIjpbMCwwLDAsMCwwXSwibW9kZSI6IlNwaW4iLCJyYW5kIjo1fSwieWF3Ijp7ImJhc2UiOiJBdCB0YXJnZXRzIiwibGVmdCI6LTI0LCJnbG9iYWwiOjAsInJpZ2h0IjozOH0sImRlZmVuc2l2ZSI6eyJmb3JjZSI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwib3ZlcnJpZGUiOnRydWUsInNldHRpbmdzIjp7InBpdGNoX3NwZWVkIjoxMCwicGl0Y2hfdmFsIjotMzUsInBpdGNoIjoiQ3VzdG9tIiwiZGlzYWJsZXJzIjpbIn4iXSwieWF3X3ZhbCI6MCwieWF3X3NwZWVkIjoxMCwieWF3IjoiWWF3IE9wcG9zaXRlIiwiZHVyYXRpb24iOjExfX19LCJTbG93d2Fsa2luZyI6eyJib2R5Ijp7InNpZGUiOjAsInlhdyI6IkppdHRlciIsImRlbGF5Ijp7InJpZ2h0IjoxLCJsZWZ0Ijo1LCJkZWxheSI6MSwibW9kZSI6IlN3aXRjaCIsInN3aXRjaCI6NH19LCJlbmFibGVkIjp0cnVlLCJqaXR0ZXIiOnsidmFsdWUyIjoxNSwidmFsdWUiOjAsInR5cGUiOiJPZmZzZXQiLCJ3YXlzIjpbMCwwLDAsMCwwXSwibW9kZSI6IlNwaW4iLCJyYW5kIjoxMH0sInlhdyI6eyJiYXNlIjoiQXQgdGFyZ2V0cyIsImxlZnQiOjE5LCJnbG9iYWwiOjAsInJpZ2h0IjotMX0sImRlZmVuc2l2ZSI6eyJmb3JjZSI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwib3ZlcnJpZGUiOnRydWUsInNldHRpbmdzIjp7InBpdGNoX3NwZWVkIjoxNywicGl0Y2hfdmFsIjowLCJwaXRjaCI6IlByb2dyZXNzaXZlIiwiZGlzYWJsZXJzIjpbIn4iXSwieWF3X3ZhbCI6MCwieWF3X3NwZWVkIjoyNCwieWF3IjoiUHJvZ3Jlc3NpdmUiLCJkdXJhdGlvbiI6MTF9fX0sIkZha2UgTGFnIjp7ImJvZHkiOnsic2lkZSI6MCwieWF3IjoiT3Bwb3NpdGUiLCJkZWxheSI6eyJyaWdodCI6MSwibGVmdCI6MSwiZGVsYXkiOjEsIm1vZGUiOiJTdGF0aWMiLCJzd2l0Y2giOjB9fSwiaml0dGVyIjp7InZhbHVlMiI6MjIsInZhbHVlIjotMjIsInR5cGUiOiJPZmZzZXQiLCJ3YXlzIjpbMCwwLDAsMCwwXSwibW9kZSI6IlNwaW4iLCJyYW5kIjo2fSwieWF3Ijp7ImJhc2UiOiJBdCB0YXJnZXRzIiwibGVmdCI6MCwiZ2xvYmFsIjowLCJyaWdodCI6MH0sImVuYWJsZWQiOnRydWV9LCJKdW1waW5nIjp7ImJvZHkiOnsic2lkZSI6MCwieWF3IjoiSml0dGVyIiwiZGVsYXkiOnsicmlnaHQiOjMsImxlZnQiOjIsImRlbGF5IjozLCJtb2RlIjoiU3dpdGNoIiwic3dpdGNoIjozfX0sImVuYWJsZWQiOnRydWUsImppdHRlciI6eyJ2YWx1ZTIiOjEyLCJ2YWx1ZSI6LTEsInR5cGUiOiJPZmZzZXQiLCJ3YXlzIjpbMCwwLDAsMCwwXSwibW9kZSI6IlNwaW4iLCJyYW5kIjo3fSwieWF3Ijp7ImJhc2UiOiJBdCB0YXJnZXRzIiwibGVmdCI6LTI5LCJnbG9iYWwiOjAsInJpZ2h0Ijo0OX0sImRlZmVuc2l2ZSI6eyJmb3JjZSI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwib3ZlcnJpZGUiOnRydWUsInNldHRpbmdzIjp7InBpdGNoX3NwZWVkIjoxMCwicGl0Y2hfdmFsIjowLCJwaXRjaCI6Ik5vbmUiLCJkaXNhYmxlcnMiOlsifiJdLCJ5YXdfdmFsIjowLCJ5YXdfc3BlZWQiOjEwLCJ5YXciOiJTcGluIiwiZHVyYXRpb24iOjEwfX19LCJEZWZhdWx0Ijp7ImRlZmVuc2l2ZSI6eyJlbmFibGVkIjpmYWxzZSwiZm9yY2UiOmZhbHNlLCJzZXR0aW5ncyI6eyJwaXRjaF9zcGVlZCI6MTAsInBpdGNoX3ZhbCI6MCwicGl0Y2giOiJOb25lIiwiZGlzYWJsZXJzIjpbIn4iXSwieWF3X3ZhbCI6MCwieWF3X3NwZWVkIjoxMCwieWF3IjoiTm9uZSIsImR1cmF0aW9uIjoxM319LCJib2R5Ijp7InNpZGUiOjAsInlhdyI6Ik9mZiIsImRlbGF5Ijp7InJpZ2h0IjoxLCJsZWZ0IjoxLCJkZWxheSI6MSwibW9kZSI6IlN0YXRpYyIsInN3aXRjaCI6MH19LCJ5YXciOnsiYmFzZSI6IkF0IHRhcmdldHMiLCJsZWZ0IjowLCJnbG9iYWwiOjAsInJpZ2h0IjowfSwiaml0dGVyIjp7InZhbHVlMiI6MCwidmFsdWUiOjAsInR5cGUiOiJPZmYiLCJ3YXlzIjpbMCwwLDAsMCwwXSwibW9kZSI6IlN0YXRpYyIsInJhbmQiOjB9fSwiU2FmZSBIZWFkIjp7ImRlZmVuc2l2ZSI6eyJmb3JjZSI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwib3ZlcnJpZGUiOnRydWUsInNldHRpbmdzIjp7InBpdGNoX3NwZWVkIjoxMCwicGl0Y2hfdmFsIjowLCJwaXRjaCI6IkN1c3RvbSIsImRpc2FibGVycyI6WyJ+Il0sInlhd192YWwiOjAsInlhd19zcGVlZCI6MTAsInlhdyI6IlByb2dyZXNzaXZlIiwiZHVyYXRpb24iOjEzfX0sInlhdyI6eyJiYXNlIjoiQXQgdGFyZ2V0cyIsImxlZnQiOjAsImdsb2JhbCI6MCwicmlnaHQiOjB9LCJqaXR0ZXIiOnsidmFsdWUyIjozLCJ2YWx1ZSI6LTMsInR5cGUiOiJPZmZzZXQiLCJ3YXlzIjpbMCwwLDAsMCwwXSwibW9kZSI6IlNwaW4iLCJyYW5kIjo0fSwiY29uZGl0aW9ucyI6WyJKdW1waW5nIiwiQ3JvdWNoaW5nIEFpciIsIn4iXSwiYm9keSI6eyJzaWRlIjowLCJ5YXciOiJPcHBvc2l0ZSIsImRlbGF5Ijp7InJpZ2h0IjoxLCJsZWZ0IjoxLCJkZWxheSI6MSwibW9kZSI6IlN0YXRpYyIsInN3aXRjaCI6MH19LCJ3ZWFwb25zIjpbIktuaWZlIiwiWmV1cyIsIn4iXSwiZW5hYmxlZCI6dHJ1ZX0sIk1hbnVhbCB5YXciOnsiZGVmZW5zaXZlIjp7ImZvcmNlIjp0cnVlLCJlbmFibGVkIjp0cnVlLCJvdmVycmlkZSI6dHJ1ZSwic2V0dGluZ3MiOnsicGl0Y2hfc3BlZWQiOjEwLCJwaXRjaF92YWwiOjAsInBpdGNoIjoiQ3VzdG9tIiwiZGlzYWJsZXJzIjpbIn4iXSwieWF3X3ZhbCI6MCwieWF3X3NwZWVkIjoxMCwieWF3IjoiWWF3IE9wcG9zaXRlIiwiZHVyYXRpb24iOjEzfX0sImJvZHkiOnsic2lkZSI6MCwieWF3IjoiT2ZmIiwiZGVsYXkiOnsicmlnaHQiOjEsImxlZnQiOjEsImRlbGF5IjoxLCJtb2RlIjoiU3RhdGljIiwic3dpdGNoIjowfX0sInlhdyI6eyJiYXNlIjoiTG9jYWwgdmlldyJ9LCJqaXR0ZXIiOnsidmFsdWUyIjowLCJ2YWx1ZSI6MCwidHlwZSI6Ik9mZiIsIndheXMiOlswLDAsMCwwLDBdLCJtb2RlIjoiU3RhdGljIiwicmFuZCI6MH19LCJSdW5uaW5nIjp7ImJvZHkiOnsic2lkZSI6MCwieWF3IjoiSml0dGVyIiwiZGVsYXkiOnsicmlnaHQiOjEsImxlZnQiOjQsImRlbGF5IjoxLCJtb2RlIjoiU3dpdGNoIiwic3dpdGNoIjozfX0sImVuYWJsZWQiOnRydWUsImppdHRlciI6eyJ2YWx1ZTIiOjI1LCJ2YWx1ZSI6MCwidHlwZSI6IlJhbmRvbSIsIndheXMiOlswLDAsMCwwLDBdLCJtb2RlIjoiU3BpbiIsInJhbmQiOjV9LCJ5YXciOnsiYmFzZSI6IkF0IHRhcmdldHMiLCJsZWZ0Ijo4LCJnbG9iYWwiOjAsInJpZ2h0IjotMX0sImRlZmVuc2l2ZSI6eyJmb3JjZSI6ZmFsc2UsImVuYWJsZWQiOnRydWUsIm92ZXJyaWRlIjp0cnVlLCJzZXR0aW5ncyI6eyJwaXRjaF9zcGVlZCI6MTAsInBpdGNoX3ZhbCI6NDUsInBpdGNoIjoiQ3VzdG9tIiwiZGlzYWJsZXJzIjpbIn4iXSwieWF3X3ZhbCI6MCwieWF3X3NwZWVkIjoxMCwieWF3IjoiU2lkZXdheXMiLCJkdXJhdGlvbiI6MTB9fX0sIlN0YW5kaW5nIjp7ImJvZHkiOnsic2lkZSI6MCwieWF3IjoiSml0dGVyIiwiZGVsYXkiOnsicmlnaHQiOjEsImxlZnQiOjQsImRlbGF5IjoyLCJtb2RlIjoiU3dpdGNoIiwic3dpdGNoIjozfX0sImVuYWJsZWQiOnRydWUsImppdHRlciI6eyJ2YWx1ZTIiOjAsInZhbHVlIjowLCJ0eXBlIjoiT2ZmIiwid2F5cyI6WzAsMCwwLDAsMF0sIm1vZGUiOiJTdGF0aWMiLCJyYW5kIjowfSwieWF3Ijp7ImJhc2UiOiJBdCB0YXJnZXRzIiwibGVmdCI6LTE1LCJnbG9iYWwiOjAsInJpZ2h0Ijo0Mn0sImRlZmVuc2l2ZSI6eyJmb3JjZSI6ZmFsc2UsImVuYWJsZWQiOnRydWUsIm92ZXJyaWRlIjp0cnVlLCJzZXR0aW5ncyI6eyJwaXRjaF9zcGVlZCI6MTAsInBpdGNoX3ZhbCI6MCwicGl0Y2giOiJOb25lIiwiZGlzYWJsZXJzIjpbIn4iXSwieWF3X3ZhbCI6MCwieWF3X3NwZWVkIjoxMCwieWF3IjoiUHJvZ3Jlc3NpdmUiLCJkdXJhdGlvbiI6N319fX0sIm90aGVyMiI6eyJmbGljayI6dHJ1ZSwiZmxpY2tfaCI6WzEsMCwifiJdLCJmbGlja19hYSI6eyJwaXRjaF9zcGVlZCI6MTAsInBpdGNoX3ZhbCI6LTQ1LCJwaXRjaCI6IkN1c3RvbSIsImRpc2FibGVycyI6WyJ+Il0sInlhd192YWwiOjAsInlhdyI6IlByb2dyZXNzaXZlIiwieWF3X3NwZWVkIjoxMH0sImRlZmVuc2l2ZSI6ZmFsc2V9LCJob3RrZXlzIjp7InJpZ2h0IjpbMiwwLCJ+Il0sImxlZnQiOlsyLDAsIn4iXSwiZWRnZSI6WzEsMCwifiJdLCJmb3J3YXJkIjpbMiwwLCJ+Il0sImZzIjpbMSwwLCJ+Il0sImZzX2Rpc2FibGVycyI6WyJ+Il19LCJvdGhlciI6eyJhdm9pZF9iYWNrc3RhYiI6dHJ1ZSwiZmxfZGlzYWJsZXIiOlsiTm90IG1vdmluZyIsIn4iXSwibGFkZGVyIjp0cnVlfX0sIkZlYXR1cmVzIjp7ImNvbG9yIjp7InByZWRpY3Rpb24gZXJyb3JfYyI6IiNGRjdEN0RGRiIsImhpdF9jIjoiI0I0RTYxRUZGIiwidW5wcmVkaWN0ZWQgb2NjYXNpb25fYyI6IiNGRjdEN0RGRiIsImRlYXRoX2MiOiIjNjQ2NEZGRkYiLCJzcHJlYWRfYyI6IiNGRkM4MDBGRiIsIj9fYyI6IiNGRjAwMDBGRiJ9LCJ2aWV3bW9kZWwiOnsic2NvcGUiOmZhbHNlLCJmb3YiOjYwLCJ5IjoxMCwieiI6LTEwLCJvbiI6ZmFsc2UsIngiOjEwfSwiYXNwZWN0Ijp7InJhdGlvIjo1OSwib24iOmZhbHNlfSwibWFya2VyIjp7InNpemUiOjUsImV4dHJhIjp0cnVlLCJ0aW1lIjozMCwic3R5bGUiOiJTdHlsZTogQ3Jvc3MiLCJvbiI6dHJ1ZX0sIndhdGVybWFyayI6eyJjdXN0b20iOiIiLCJsb2NrIjoiQm90dG9tLUNlbnRlciIsImNvbG9yIjp7IkJhY2tncm91bmQiOnsicGlja2VyIjoiI0FGQUZGRkI5IiwicHJlc2V0IjoiQmFja2dyb3VuZDogRGVmYXVsdCJ9LCJUZXh0Ijp7InBpY2tlciI6IiNBRkFGRkZCOSIsInByZXNldCI6IlRleHQ6IERlZmF1bHQifX0sImVsZW1lbnRzIjpbIk5pY2tuYW1lIiwiRlBTIiwiUGluZyIsIlRpbWUiLCJ+Il0sIm9uIjp0cnVlLCJ1c2VkIjp0cnVlfSwidHJhY2VyIjp7InRpbWUiOjIwLCJvbiI6dHJ1ZSwiY29sb3IiOnsiQ29sb3IiOnsicGlja2VyIjoiI0ZGRkZGRkM4IiwicHJlc2V0IjoiQ29sb3I6IERlZmF1bHQifX19LCJjb25zb2xlIjp7Im9uIjp0cnVlfSwiaGVscGVyIjp7ImNvbG9yIjp7IkNvbG9yIjp7InBpY2tlciI6IiNGRkZGRkY0QiIsInByZXNldCI6IkNvbG9yOiBEZWZhdWx0In19LCJvbiI6dHJ1ZSwidGhpcmQiOiJUaGlyZHBlcnNvbjogTG9jYWwgUGxheWVyIiwiZmlyc3QiOiJGaXJzdHBlcnNvbjogQ3Jvc3NoYWlyIn0sImFuaW1hdGlvbnMiOnsiZXh0cmEiOlsiTGFuZGluZyBQaXRjaCIsIn4iXSwib24iOnRydWUsImFpciI6IlN0YXRpYyIsImdyb3VuZCI6IkppdHRlciJ9LCJzaGFyZWQiOnsib24iOmZhbHNlLCJib3giOjB9LCJjcm9zc2hhaXIiOnsic2V0dGluZ3MiOnsiRG91YmxlIFRhcCI6eyJvbiI6dHJ1ZSwiY29udGFpbmVyIjp7Im5hbWUiOiIiLCJjb2xvciI6eyJEb3VibGUgVGFwIjp7InBpY2tlciI6IiNGRkZGRkZGRiIsInByZXNldCI6IkRvdWJsZSBUYXA6IERlZmF1bHQifX19fSwiUmlubmVnYW4iOnsib24iOnRydWUsImNvbnRhaW5lciI6eyJuYW1lIjoiIiwiY29sb3IiOnsiUmlubmVnYW4iOnsicGlja2VyIjoiI0ZGRkZGRkZGIiwicHJlc2V0IjoiUmlubmVnYW46IERlZmF1bHQifSwiQWJ5c3MiOnsicGlja2VyIjoiI0ZGRkZGRkZGIiwicHJlc2V0IjoiQWJ5c3M6IERlZmF1bHQifX19fSwiQ29uZGl0aW9ucyI6eyJvbiI6dHJ1ZSwiY29udGFpbmVyIjp7Im5hbWUiOiIiLCJjb2xvciI6eyJDb25kaXRpb25zIjp7InBpY2tlciI6IiNCOUI5RkZGRiIsInByZXNldCI6IkNvbmRpdGlvbnM6IERlZmF1bHQifX19fSwiSGlkZSBTaG90cyI6eyJvbiI6dHJ1ZSwiY29udGFpbmVyIjp7Im5hbWUiOiIiLCJjb2xvciI6eyJIaWRlIFNob3RzIjp7InBpY2tlciI6IiNGRkZGRkZGRiIsInByZXNldCI6IkhpZGUgU2hvdHM6IERlZmF1bHQifX19fSwiUGluZyBTcGlrZSI6eyJvbiI6dHJ1ZSwiY29udGFpbmVyIjp7Im5hbWUiOiIiLCJjb2xvciI6eyJQaW5nIFNwaWtlIjp7InBpY2tlciI6IiNGRkZGRkZGRiIsInByZXNldCI6IlBpbmcgU3Bpa2U6IERlZmF1bHQifX19fSwiU2FmZSBQb2ludHMiOnsib24iOnRydWUsImNvbnRhaW5lciI6eyJuYW1lIjoiIiwiY29sb3IiOnsiU2FmZSBQb2ludHMiOnsicGlja2VyIjoiI0ZGRkZGRkZGIiwicHJlc2V0IjoiU2FmZSBQb2ludHM6IERlZmF1bHQifX19fSwiRnJlZXN0YW5kaW5nIjp7Im9uIjp0cnVlLCJjb250YWluZXIiOnsibmFtZSI6IiIsImNvbG9yIjp7IkZyZWVzdGFuZGluZyI6eyJwaWNrZXIiOiIjRkZGRkZGRkYiLCJwcmVzZXQiOiJGcmVlc3RhbmRpbmc6IERlZmF1bHQifX19fSwiQm9keSBBaW0iOnsib24iOnRydWUsImNvbnRhaW5lciI6eyJuYW1lIjoiIiwiY29sb3IiOnsiQm9keSBBaW0iOnsicGlja2VyIjoiI0ZGRkZGRkZGIiwicHJlc2V0IjoiQm9keSBBaW06IERlZmF1bHQifX19fSwiRmxpY2tpbmciOnsib24iOnRydWUsImNvbnRhaW5lciI6eyJuYW1lIjoiIiwiY29sb3IiOnsiRmxpY2tpbmciOnsicGlja2VyIjoiI0ZGRkZGRkZGIiwicHJlc2V0IjoiRmxpY2tpbmc6IERlZmF1bHQifX19fSwiTWluLiBEYW1hZ2UiOnsib24iOnRydWUsImNvbnRhaW5lciI6eyJuYW1lIjoiIiwiY29sb3IiOnsiTWluLiBEYW1hZ2UiOnsicGlja2VyIjoiI0ZGRkZGRkZGIiwicHJlc2V0IjoiTWluLiBEYW1hZ2U6IERlZmF1bHQifX19fSwiSGl0Y2hhbmNlIjp7Im9uIjp0cnVlLCJjb250YWluZXIiOnsibmFtZSI6IiIsImNvbG9yIjp7IkhpdGNoYW5jZSI6eyJwaWNrZXIiOiIjRkZGRkZGRkYiLCJwcmVzZXQiOiJIaXRjaGFuY2U6IERlZmF1bHQifX19fX0sImJveCI6MCwib24iOnRydWUsInVzZWQiOnRydWV9LCJjbGFudGFnIjp7Im9uIjp0cnVlfSwicXVha2UiOnsidm9sdW1lIjo1MCwiaW1hZ2UiOmZhbHNlLCJvbiI6ZmFsc2V9LCJtYW51YWwiOnsib24iOnRydWUsImNvbG9yIjp7IkNvbG9yIjp7InBpY2tlciI6IiNGRkZGRkZDOCIsInByZXNldCI6IkNvbG9yOiBEZWZhdWx0In19fSwic2NvcGUiOnsiY29sb3IiOnsiQ29sb3IiOnsicGlja2VyIjoiI0ZGRkZGRkM4IiwicHJlc2V0IjoiQ29sb3I6IERlZmF1bHQifX0sImdhcCI6MTAsImRhbGJhZWIyIjpmYWxzZSwic3R5bGUiOiJTdHlsZTogUGx1cyIsImxlbmd0aCI6NTAsIm9uIjp0cnVlLCJkYWxiYWViIjowfSwidHJhc2h0YWxrIjp7ImV2ZW50IjpbIk9uIEtpbGwiLCJPbiBEZWF0aCIsIn4iXSwib24iOnRydWUsInVzZWQiOmZhbHNlfSwiaGl0Y2hhbmNlIjp7ImJveCI6MCwib24iOmZhbHNlLCJzZXR0aW5ncyI6eyJNYWNoaW5lIGd1biI6eyJzY29wZSI6eyJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9LCJidXR0b24iOnsiaG90a2V5IjpbMSwwLCJ+Il0sIm9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH0sImFpciI6eyJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9fSwiQXV0b3NuaXBlcnMiOnsic2NvcGUiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfSwiYnV0dG9uIjp7ImhvdGtleSI6WzEsMCwifiJdLCJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9LCJhaXIiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfX0sIlNNRyI6eyJzY29wZSI6eyJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9LCJidXR0b24iOnsiaG90a2V5IjpbMSwwLCJ+Il0sIm9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH0sImFpciI6eyJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9fSwiU1NHIDA4Ijp7InNjb3BlIjp7Im9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH0sImJ1dHRvbiI6eyJob3RrZXkiOlsxLDAsIn4iXSwib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfSwiYWlyIjp7Im9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH19LCJEZXNlcnQgRWFnbGUiOnsic2NvcGUiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfSwiYnV0dG9uIjp7ImhvdGtleSI6WzEsMCwifiJdLCJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9LCJhaXIiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfX0sIlJpZmxlIjp7InNjb3BlIjp7Im9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH0sImJ1dHRvbiI6eyJob3RrZXkiOlsxLDAsIn4iXSwib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfSwiYWlyIjp7Im9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH19LCJHbG9iYWwiOnsic2NvcGUiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfSwiYnV0dG9uIjp7ImhvdGtleSI6WzEsMCwifiJdLCJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9LCJhaXIiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfX0sIlpldXMiOnsic2NvcGUiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfSwiYnV0dG9uIjp7ImhvdGtleSI6WzEsMCwifiJdLCJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9LCJhaXIiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfX0sIlI4IFJldm9sdmVyIjp7InNjb3BlIjp7Im9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH0sImJ1dHRvbiI6eyJob3RrZXkiOlsxLDAsIn4iXSwib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfSwiYWlyIjp7Im9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH19LCJQaXN0b2wiOnsic2NvcGUiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfSwiYnV0dG9uIjp7ImhvdGtleSI6WzEsMCwifiJdLCJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9LCJhaXIiOnsib24iOmZhbHNlLCJoaXRjaGFuY2UiOjUwfX0sIkFXUCI6eyJzY29wZSI6eyJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9LCJidXR0b24iOnsiaG90a2V5IjpbMSwwLCJ+Il0sIm9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH0sImFpciI6eyJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9fSwiU2hvdGd1biI6eyJzY29wZSI6eyJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9LCJidXR0b24iOnsiaG90a2V5IjpbMSwwLCJ+Il0sIm9uIjpmYWxzZSwiaGl0Y2hhbmNlIjo1MH0sImFpciI6eyJvbiI6ZmFsc2UsImhpdGNoYW5jZSI6NTB9fX19LCJkYW1hZ2UiOnsiYW5pbWF0aW9uIjoiQW5pbWF0aW9uOiBJbnN0YW50IiwiY29sb3IiOnsiQ29sb3IiOnsicGlja2VyIjoiI0ZGRkZGRkM4IiwicHJlc2V0IjoiQ29sb3I6IERlZmF1bHQifX0sImZvbnQiOiJGb250OiBEZWZhdWx0Iiwib24iOnRydWUsImRpc3BsYXkiOiJEaXNwbGF5OiBBbHdheXMgT24iLCJkcmFnIjp7InkiOjUwMCwieCI6NTAwfX0sImxvZ3MiOnsiY29sb3IiOnsiQmFja2dyb3VuZCI6eyJwaWNrZXIiOiIjMDAwMDAwNjQiLCJwcmVzZXQiOiJCYWNrZ3JvdW5kOiBEZWZhdWx0In19LCJvbiI6dHJ1ZSwidGltZSI6MzAsImRpc3BsYXkiOlsiT24gU2NyZWVuIiwiSW4gQ29uc29sZSIsIn4iXSwidXNlZCI6dHJ1ZX0sInpvb20iOnsic2Vjb25kIjo1MCwidGhpcmQiOjMwLCJtb2RlIjoiTW9kZTogU2luZ2xlIiwic3RhY2siOmZhbHNlLCJidXR0b24iOlsxLDAsIn4iXSwib24iOmZhbHNlLCJmaXJzdCI6MzB9fX0='

    db.db.configs['Local'][1] = {"Default", default_cfg}
    db.configs = {"Default"}

    -- db.configs['Cloud'] = {"Default Cloud", 'new aa', 'govno aa', 'ez 123', 'ok'}
    -- db.configs.authors = {'qqwerty', 'debil', 'esoterik', 'dalbaeb'}

end

local gradient do
    gradient = {}
    gradient.animated_gradient_text = function(text, colors, speed, a)
        local output = ""
        local length = #text
        local time_offset = (utils.normalize_yaw(globals.realtime() * speed, 1, 3) * speed) % 1
    
        for i = 1, length do
            -- Если символ '·', присваиваем ему фиксированный цвет
            if text:sub(i, i) == "·" then
                output = output .. string.format("\a%02x%02x%02x%02x", 185, 185, 255, 255) .. text:sub(i, i)
            else
                -- Иначе применяем градиентный цвет
                local t = ((i - 1) / (length - 1) + time_offset) % 1
                local color = color.linear_gradient(colors, t)
                color:alpha_modulate(utils.sine_yaw(globals.framecount() / i % 3 * (0.92 - i % 5), 0, 255))
                output = output .. string.format("\a%02x%02x%02x%02x", color.r, color.g, color.b, color.a * a) .. text:sub(i, i)
            end
        end
    
        return output
    end
    
    
    gradient.randomize_colors = function(count)
        local randomized_colors = {}
    
        -- Устанавливаем шаг для плавного изменения t от 0 до 1
        local step = 1 / (count - 1)
    
        for i = 1, count do
            -- Рандомные значения для цвета (r, g, b, a) в допустимых диапазонах
            local r = math.random(150, 240)
            local g = math.random(150, 200)
            local b = math.random(250, 255)
            local a = math.random(100, 255)
    
            -- t увеличивается от 0 до 1
            local t = (i - 1) * step
    
            -- Добавляем цвет в таблицу
            table.insert(randomized_colors, { color(r, g, b, a), t })
        end
    
        return randomized_colors
    end
    -- Генерация случайных 10 цветов
    gradient.table = gradient.randomize_colors(100)
end

local drag do
    local is_menu_visible = false
    local is_mouse_held_before_hover = false
    local mouse = vector()

    drag = {}
    drag.windows = {}

    function drag.on_config_load()
        for _, point in pairs(drag.windows) do
            point.position = vector(point.ui_callbacks.x:get()*screen.size.x/1000, point.ui_callbacks.y:get()*screen.size.y/1000)
        end
    end

    function drag.register(position, size, global_name, ins_function, limits, outline)
        local data = {
            size = size,
            is_dragging = false,
            drag_position = vector(),
            is_mouse_held_before_hover = false, -- теперь локально для каждого элемента
            global_name = global_name,
            ins_function = ins_function,
            ui_callbacks = {x = position.x, y = position.y},
            limits = limits and {x={min=limits[1], max=limits[2]}, y={min=limits[3],max=limits[4]}} or nil,
            outline = outline == nil and true or outline
        }
        data.position = vector(data.ui_callbacks.x.value/1000*screen.size.x - data.size.x/2, data.ui_callbacks.y.value/1000*screen.size.y - data.size.y/2)
         
        table.insert(drag.windows, data)
        return setmetatable(data, { __index = drag })
    end
    
    
    function drag:limit_positions(table)
        self.position.x = math.max(table and table.x.min or 0, math.min(self.position.x, table and table.x.max or screen.size.x - self.size.x))
        self.position.y = math.max(table and table.y.min or 0, math.min(self.position.y, table and table.y.max or screen.size.y - self.size.y))
    end
    
    function drag:is_in_area(mouse_position)
        return mouse_position.x >= self.position.x and mouse_position.x <= self.position.x + self.size.x and 
               mouse_position.y >= self.position.y and mouse_position.y <= self.position.y + self.size.y
    end
    
    function drag:update(...)
        if is_menu_visible then
            if self.outline then
                utils.rectangle_outline(self.position.x, self.position.y, self.size.x, self.size.y, 255, 255, 255, 100)
            end
            local is_in_area = self:is_in_area(mouse)
            local is_key_pressed = client.key_state(0x01)
    
            if is_in_area and client.key_state(0x02) then
                self.position.x = (screen.size.x - self.size.x) / 2
                self.ui_callbacks.x:set(math.floor(self.position.x / screen.size.x * 1000))
            end
    
            if is_key_pressed and not self.is_dragging and not is_in_area then
                self.is_mouse_held_before_hover = true
            end
    
            if (is_in_area or self.is_dragging) and is_key_pressed and not self.is_mouse_held_before_hover then
                if not self.is_dragging then
                    self.is_dragging = true
                    self.drag_position = mouse - self.position
                else
                    self.position = mouse - self.drag_position
                    self:limit_positions(self.limits)
                    self.ui_callbacks.x:set(math.floor(self.position.x/screen.size.x*1000))
                    self.ui_callbacks.y:set(math.floor(self.position.y/screen.size.y*1000))
                end
            elseif not is_key_pressed then
                self.is_dragging = false
                self.drag_position = vector()
                self.is_mouse_held_before_hover = false
            end
        end
        self.ins_function(self, ...)
    end
    
    local function block(cmd)
        cmd.in_attack = false
        cmd.in_attack2 = false
    end
    
    local function mouse_input()
        height = vector(renderer.measure_text('d', '1')).y
        is_menu_visible = ui.is_menu_open()
        if is_menu_visible then
            mouse = vector(ui.mouse_position())
            local is_key_pressed = client.key_state(0x01)
            local in_area = false
            if is_menu_visible then
                for _, window in pairs(drag.windows) do
                    if window.is_dragging or window:is_in_area(mouse) then
                        in_area = true
                        break
                    end
                end
            end
            
            if in_area then
                client.set_event_callback("setup_command", block)
            else
                client.unset_event_callback("setup_command", block)
            end

            
            if not is_key_pressed then
                is_mouse_held_before_hover = false
            end
            
            return not in_area
        end
    end
    
    client.set_event_callback("paint", mouse_input)
end 

local menu do
    menu = {}

    local hide_menu do
        hide_menu = function()
            -- for _,table in pairs(refs) do
                -- for _, ref in pairs(table) do
                for _, ref in pairs(refs.aa) do
                    ref:set_visible(false)
                end
            -- end
        end
        client.set_event_callback("paint_ui", hide_menu)
    end

    local tabs do
        tabs = {
            aa = pui.group("AA", "Anti-aimbot angles"),
            fl = pui.group("AA", "Fake lag"),
            other = pui.group("AA", "Other")
        }
    end

    local tab = tabs.fl:combobox("\vRinnegan ["..version[1].."]", {"Home", "Features", "Antiaims"}, false)
    local tab_label = tabs.fl:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾")

    local setup = tabs.aa:combobox("Setup", {
        "None", "Crosshair Indicator", "Damage Indicator", "Manual Yaw Indicator", 
        "Custom Scope", "Thirdperson Distance", "Ragebot Logs", "Shot Marker",
        "Bullet Tracer", "Damage Helper", "Console Filter", "Trashtalk",
        "Watermark", "Hitchance Modifier", "Aspect Ratio", "Viewmodel",
        "Shared Logo", "Animations", "Clantag", "Quake Sounds", "Stickman", 
        "Velocity Warning", "Defensive indicator", "Gamesense Indicator",
        "Bomb Indicator"
    }, false)
    setup:set_visible(false)
    local disabled = {
        ["Shared Logo"] = true,
        ["Quake Sounds"] = true,
        -- ["Stickman"] = true,
    }

    local Home = {} do
        local types = {"Local", "Cloud"}

        local aa do
            aa = {}

            aa.config_label = tabs.aa:label("\vConfig System")
            aa.divider = tabs.aa:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾")
            aa.type = tabs.aa:combobox("\n", types, nil, false)
            aa.type:set_enabled(false)
            aa.sort = tabs.aa:combobox("\n", {"Sort by: Last Update", "Sort by: First Created"}, nil, false)
                :depend({aa.type, 'Cloud'})

            aa.box = tabs.aa:listbox("Config system", db.configs, nil, false)

            aa.selected_label = tabs.aa:label("Selected - \vDefault")
            aa.load = tabs.aa:button("Load")
            aa.loadaa = tabs.aa:button("Load AA")

            aa.save = tabs.aa:button("Save")
                :depend({aa.type, 'Local'}, {aa.box, 0, true})
            aa.export = tabs.aa:button("Export")
                :depend({aa.type, 'Local'}, {aa.box, 0, true})
            aa.delete = tabs.aa:button("\aFF0000FFDelete")
                :depend({aa.type, 'Local'}, {aa.box, 0, true})

            -- aa.type:set_callback(function(self)
            --     aa.box:invoke()
            -- end)
            aa.box:set_callback(function(self)
                local table = {}
                if aa.type.value == 'Cloud' then
                    for i=1, #db.configs['Cloud'] do
                        table[i] = i == 1 and db.configs['Cloud'][1] or pui.format('\r[\v'..db.configs.authors[i - 1]..'\r] ~ '.. (i == self.value + 1 and '\v' or '') .. db.configs['Cloud'][i])
                    end
                else
                    table = db.configs
                end
                self:update(table)
                aa.selected_label:set("Selected - \v"..table[self.value + 1])
                client.exec('playvol buttons\\lightswitch2 0.5')
            end, true)

            Home.aa = aa
        end

        local fl do 
            local session = 0
            fl = {
                a = tabs.fl:label("\n123"),
                played = tabs.fl:label("Total Playtime: \v" .. string.format(db.db.data.time < 3600 and "%.2f" or "%.0f", db.db.data.time / 3600) .. " hours"),
                session = tabs.fl:label("Current Session: \v"..session),
                loaded = tabs.fl:label("Times Loaded: \v"..db.db.data.loaded),
                killed = tabs.fl:label("Times Killed: \v"..db.db.data.killed),
            }
            local update_session = function() end
            update_session = function()
                session = globals.realtime() - db.loaded
                fl.played:set("Total Playtime: \v" .. string.format(db.db.data.time < 3600 and "%.2f" or "%.0f", db.db.data.time / 3600) .. " hours")
                fl.session:set("Session time: \v"..math.floor(session)..' sec')
                fl.killed:set("Times Killed: \v"..db.db.data.killed)
                client.delay_call(1, update_session)
            end update_session()

            Home.fl = fl
        end

        local other do
            other = {
                Local = {
                    autoload = tabs.other:checkbox("Autoload last config", nil, false),
                    autoload_save = tabs.other:multiselect("Save config on", {"Load", "Save", "Shutdown"}, nil, false),
                    label_cfg_name = tabs.other:label("\vConfig Name"),
                    name = tabs.other:textbox("Config name", nil, false),
                    create = tabs.other:button("Create & Save"),
                    import = tabs.other:button("Import & Load")
                },


                Cloud = {
                    selected = tabs.other:combobox("\vSelect Config", db.configs, nil, false),
                    upload = tabs.other:button("\vUpload to Cloud"),
                    -- Добавлять с timestamp
                },

                -- label_ds = tabs.other:label("\n"),
                -- discord = tabs.other:button("Join to Discord")
            }
            other.Local.autoload:set(db.db.last.on)
            other.Local.autoload:set_callback(function(self)
                db.db.last.on = self.value
                db.save()
            end)
            other.Local.autoload_save:set(db.db.last.save or {})
            other.Local.autoload_save:depend({other.Local.autoload, true})
            other.Local.autoload_save:set_callback(function(self)
                db.db.last.save = self.value
                db.save()
            end)

            for _, name in pairs(types) do
                for _, el in pairs(other[name]) do
                    el:depend({Home.aa.type, name})
                end
            end

            Home.other = other
        end

        menu.Home = Home
    end

    local Features = {} do
        local create = {} do
            local unique = 1
            create.element = function(tab, name)
                local el = {}

                el.disabled = tab:checkbox("Setup \aC8C8C8C8"..name, nil, false)
                el.enabled = tab:checkbox("Setup \v"..name, false, false)
                el.divider = tab:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\n"..unique)
                el.on = tab:checkbox("Enabled\n"..name)
                el.divider2 = tab:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\n"..unique)

                if disabled[name] then
                    el.disabled:set_enabled(false)
                    el.enabled:set_enabled(false)
                    el.on:set_enabled(false)
                end
                
                el.disabled:depend( {el.on, false} )
                el.enabled:depend( {el.on, true} )
                el.divider:depend( {setup, name} )
                el.on:depend( {setup, name} )
    
                el.disabled:set_callback(function(self)
                    el.enabled:set(self.value)
                end)
    
                el.enabled:set_callback(function(self)
                    el.disabled:set(self.value)
                    setup:set(setup.value == 'None' and name or 'None')
                end)

                client.set_event_callback('post_config_load', function()
                    el.disabled:set(false)
                end)

                unique = unique + 1
                return el
            end --todo: при использовании, обновлять таблицу в setup

            create.color = function(tab, name, default, custom)
                local el = {}
                colors[name] = colors[name] or {}
                custom = custom or {"Color"}

                for a,b in pairs(custom) do
                    el[b] = {}
                    el[b].preset = tab:combobox("\n" .. unique, {b..": Default", b..": Accent", b..": Custom"})
                    local default = color(unpack(default[a]))
                    el[b].picker = tab:color_picker('\n' .. unique, default)
                    el[b].picker:depend({el[b].preset, b..": Custom"})

                    local col = default

                    local set_color = function()
                        col = el[b].preset.value == b..": Default" and (default) or el[b].preset.value == b..": Accent" and utils.to_rgb(pui.accent) or color(unpack(el[b].picker.value))
                        colors[name][b] = col
                    end
                    el[b].picker:set_callback(set_color)
                    el[b].preset:set_callback(set_color, true)
                    refs2.color:set_callback(set_color)
                end
                unique = unique + 1
                return el
            end

            local show_sliders = false
            create.drag = function(name, default)
                local el = {}
                el.x = tabs.aa:slider('x\n'..unique, 0, 1000, default and default[1]/screen.size.x*1000 or 500)
                el.y = tabs.aa:slider('y\n'..unique, 0, 1000, default and default[2]/screen.size.y*1000 or 500) 
                el.x:depend({setup, 'drag', show_sliders})
                el.y:depend({setup, 'drag', show_sliders})
                unique = unique + 1
                return el
            end

            create.label = function(tab, name, arg1)
                local el = {}
                if arg1 ~= true then
                    el.div0 = tab:label("\n123")
                end
                el.name = tab:label("\v"..name)
                el.div1 = tab:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾")

                for a,b in pairs(el) do
                    b:depend({setup, "None"})
                end
                return el
            end
            
        end

        Features.label1 = create.label(tabs.aa, "Visuals", true)

        local watermark = {} do
            watermark = create.element(tabs.aa, "Watermark")
            watermark.drag = create.drag("watermark", {screen.center.x, screen.size.y-100})
            watermark.on:set_enabled(false)
            watermark.on:set(true)
            watermark.candy = tabs.aa:checkbox("Candy")
            watermark.color = create.color(tabs.aa, 'watermark', { {175,175,255,185}, {0,0,0,200} },{"Text", "Background"})
            watermark.elements = tabs.aa:multiselect('\nwatermark.elements', {"Nickname", "FPS", "Ping", "Time"})
            watermark.lock = tabs.aa:combobox('\nwatermark.lock', {"Bottom-Center","Upper-Center","Upper-Right","Bottom-Right","Upper-Left","Bottom-Left", "None"})
            watermark.custom = tabs.aa:textbox("custom name watermark")
            watermark.used = tabs.aa:checkbox("Used elements?")
            watermark.used:depend({setup, 'xdadadsadadx'})
            watermark.elements:set_callback(function()
                watermark.used:set(true)
            end)
            if not watermark.used.value then
                watermark.elements:set({"Nickname", "FPS", "Ping", "Time"})
            end

            watermark.custom:depend({watermark.elements, "Nickname"})
            Features.watermark = watermark
        end

        local crosshair = {} do
            crosshair = create.element(tabs.aa, "Crosshair Indicator")
            local data = {} do
                data.always = {"Rinnegan", "Conditions"}
                data.elements = {"Rinnegan", "Conditions", "Double Tap", "Hide Shots", "Min. Damage", "Hitchance","Body Aim", "Safe Points", "Ping Spike", "Freestanding", "Flicking"}
                data.list = {table.unpack(data.elements)}
                data.names = {
                    ["Double Tap"] = "DOUBLETAP",
                    ["Hide Shots"] = "OSAA",
                    ["Min. Damage"] = "DAMAGE",
                    ["Hitchance"] = "HC",
                    ["Body Aim"] = "BAIM",
                    ["Safe Points"] = "SAFE",
                    ["Ping Spike"] = "SPIKE",
                    ["Freestanding"] = "FS",
                    ["Flicking"] = "FLICK",
                }
                data.color = {
                    ["Conditions"] = {185,185,255,255}
                }
                data.numbers = {}
                for i, name in pairs(data.elements) do
                    data.numbers[name] = i
                end

                hard['crosshair'] = data
            end

            crosshair.box = tabs.aa:listbox("\ncrosshair", data.list)
            crosshair.used = tabs.aa:checkbox("Used elements? crosshair")
            crosshair.used:depend({setup, 'xdadadsadadx'})


            local settings = {}
            for a, b in pairs(data.elements) do
                settings[b] = {}

                settings[b].on = tabs.aa:checkbox("Enabled\n"..b)
                local container = {}
                container.name = tabs.aa:textbox("Custom name"..b)
                container.color = create.color(tabs.aa, 'crosshair', a == 1 and {{255,255,255,255}, {185,185,255,255}} or { (data.color[b] or {255,255,255,255}) }, a == 1 and {b, "Version"} or {b})
                container.candy = tabs.aa:checkbox("Candy\n"..b)
                pui.traverse(container, function(element)
                    element:depend({settings[b].on, true})
                end)
                local i = 0
                settings[b].on:set_callback(function(self)
                    data.list[data.numbers[b]] = self.value and pui.format(data.elements[data.numbers[b]] ..' ~ \vEnabled') or pui.format(data.elements[data.numbers[b]] .. ' ~ \aC8C8C8C8Disabled')
                    crosshair.box:update(data.list)
                end, true)
                if data.always[data.numbers[b]] then
                    settings[b].on:set_enabled(false)
                    settings[b].on:set(true)
                    container.name:set_enabled(false)
                end

                settings[b].container = container
            end
            if not crosshair.used.value then
                pui.traverse(settings, function(element, path)
                    if path[2] == 'on' then
                        element:set(true)
                    end
                end)
            end
            pui.traverse(settings, function(element, path)
                element:depend({crosshair.box, data.numbers[path[1]] - 1})
            end)
            crosshair.settings = settings
            Features.crosshair = crosshair
        end
        
        local damage = {} do
            damage = create.element(tabs.aa, "Damage Indicator")

            damage.drag = create.drag('damage', {screen.center.x+20,screen.center.y-30})
            damage.color = create.color(tabs.aa, 'damage', {{255,255,255,200}})
            damage.font = tabs.aa:combobox("\ndamage.font", {"Font: Default", "Font: Pixel"})
            damage.display = tabs.aa:combobox("\ndamage.display", {"Display: Always On", "Display: Always On (50%)", "Display: On Hotkey"})
            damage.animation = tabs.aa:combobox("\ndamage.animation", {"Animation: Instant", "Animation: Smooth"})

            Features.damage = damage
        end

        local manual = {} do
            manual = create.element(tabs.aa, "Manual Yaw Indicator")
            manual.color = create.color(tabs.aa, 'manual', {{255,255,255,200}})

            Features.manual = manual
        end

        local gamesense = {} do
            gamesense = create.element(tabs.aa, "Gamesense Indicator")
            local data = {} do
                data.always = {['Min. Damage'] = true, ["Hit Chance"] = true}
                data.elements = {"Safe Point", "Body Aim", "Ping Spike", "Double Tap", "Fake Duck", "Freestanding", "Hide Shots", "Min. Damage", "Hit Chance"}
                data.list = {table.unpack(data.elements)}
                data.names = {
                    ["Double Tap"] = "DT",
                    ["Hide Shots"] = "OSAA",
                    ["Min. Damage"] = "DMG",
                    ["Hit Chance"] = "HC",
                    ["Body Aim"] = "BODY",
                    ["Safe Point"] = "SAFE",
                    ["Ping Spike"] = "PING",
                    ["Freestanding"] = "FS",
                    ["Fake Duck"] = "DUCK",
                }
                data.numbers = {}
                for i, name in pairs(data.elements) do
                    data.numbers[name] = i
                end

                hard['gamesense'] = data
            end
            gamesense.follow = tabs.aa:checkbox("Follow the player in thirdperson mode")
            gamesense.box = tabs.aa:listbox("\ngamesense", data.list)
            gamesense.used = tabs.aa:checkbox("Used elements? gamesense")
            gamesense.used:depend({setup, 'xdadadsadadx'})

            local settings = {}
            for a, b in pairs(data.elements) do
                settings[b] = {}

                settings[b].on = tabs.aa:checkbox("Enabled \v"..b)
                local container = {}
                container.always = data.always[b] and tabs.aa:checkbox("Always On\n"..b) or nil
                container.show = data.always[b] and tabs.aa:checkbox("Show Value\n"..b) or nil
                container.name = tabs.aa:textbox("Custom name"..b)
                container.color = create.color(tabs.aa, 'gamesense', {( b == "Ping Spike" and {150,200,25,200} or {185,185,185,255})}, {b})
                pui.traverse(container, function(element)
                    element:depend({settings[b].on, true})
                end)
                local i = 0
                settings[b].on:set_callback(function(self)
                    data.list[data.numbers[b]] = self.value and pui.format(data.elements[data.numbers[b]] ..' ~ \vEnabled') or pui.format(data.elements[data.numbers[b]] .. ' ~ \aC8C8C8C8Disabled')
                    gamesense.box:update(data.list)
                end, true)  

                settings[b].container = container
            end
            if not crosshair.used.value then
                pui.traverse(settings, function(element, path)
                    if path[2] == 'on' then
                        element:set(true)
                    end
                end)
            end
            pui.traverse(settings, function(element, path)
                element:depend({gamesense.box, data.numbers[path[1]] - 1})
            end)
            gamesense.settings = settings
            Features.gamesense = gamesense
        end

        local bomb = {} do
            bomb = create.element(tabs.aa, "Bomb Indicator")
            bomb.drag = create.drag("Bomb Indicator", {screen.center.x, screen.size.y*0.25})
            bomb.color = create.color(tabs.aa, 'bomb', {{175,175,255,255}, {220,30,50,255}}, {"Good", "Bad"})

            Features.bomb = bomb
        end

        local scope = {} do
            scope = create.element(tabs.aa, "Custom Scope")

            scope.color = create.color(tabs.aa, 'scope', {{255,255,255,200}})
            scope.style = tabs.aa:combobox("\nscope.Style", {"Style: Plus", "Style: Cross"})
            local gap,length = {},{}
            for i=0, 100 do
                gap[i] = 'Gap '..i..'px'
            end
            for i=0, 200 do
                length[i] = 'Lenght '..i..'px'
            end
            scope.gap = tabs.aa:slider("\nLines Gap", 0, 100, 10, true, "px", 1, gap)
            scope.length = tabs.aa:slider("\nLines Lenght", 0, 200, 50, true, "px", 1, length)
            scope.dalbaeb = tabs.aa:slider("dalbaeb\nLines dalbaeb", -360 , 360, 0, true, "°", 1)
            scope.dalbaeb2 = tabs.aa:checkbox("dalbaeb2\ndaun")

            scope.dalbaeb:depend({scope.style, "Style: Cross"})
            scope.dalbaeb2:depend({scope.style, "Style: Cross"})

            Features.scope = scope
        end

        local zoom = {} do
            zoom = create.element(tabs.aa, "Thirdperson Distance")
            zoom.distance = tabs.aa:slider("Thirdperson Distance", 30, 100, 58)
            zoom.div2 = tabs.aa:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\n"..'zoom')
            zoom.mode = tabs.aa:combobox("Animated Zoom\nzoom.mode", {"Mode: Single", "Mode: Dual"})
            zoom.first = tabs.aa:slider("\nZoom Fov 1", -100, 100, 30, true, '%')
            zoom.second = tabs.aa:slider("\nZoom Fov 2", -100, 100, 50, true, '%')
            zoom.second:depend({zoom.mode, 'Mode: Dual'})
            zoom.div = tabs.aa:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\n"..'zoom')
            -- zoom.button = tabs.aa:hotkey("Zoom on Hotkey")
            -- zoom.third = tabs.aa:slider("\nZoom Fov 1", 0, 100, 50, true, '%')
            -- zoom.stack = tabs.aa:checkbox("Stack with Scope Zoom")


            Features.zoom = zoom
        end

        local aspect = {} do
            aspect = create.element(tabs.aa, "Aspect Ratio")
            aspect.ratio = tabs.aa:slider("\naspect.ratio", 59, 250, 59, true, '', .01, {[59] = "Off"})

            Features.aspect = aspect
        end

        local viewmodel = {} do
            viewmodel = create.element(tabs.aa, "Viewmodel")
            local fov = {}
            for i=-200, 200 do
                fov[i] = i..' fov'
            end
            viewmodel.scope = tabs.aa:checkbox("Show weapon in scope")
            viewmodel.div = tabs.aa:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\n"..'viewmodel')
            viewmodel.fov = tabs.aa:slider("\nviewmodel.fov", 0, 100, default.viewmodel.fov, true, '', 1, fov)
            viewmodel.x = tabs.aa:slider("\nviewmodel.x", -300, 300, default.viewmodel.x * 10, true, ' x', .1)
            viewmodel.y = tabs.aa:slider("\nviewmodel.y", -300, 300, default.viewmodel.y * 10, true, ' y', .1)
            viewmodel.z = tabs.aa:slider("\nviewmodel.z", -300, 300, default.viewmodel.z * 10, true, ' z', .1)
            viewmodel.reset = tabs.aa:button("Reset")
            viewmodel.reset:set_callback(function()
                for a,_ in pairs(default.viewmodel) do
                    viewmodel[a]:reset()
                end
            end)

            Features.viewmodel = viewmodel
        end

        local velocity = {} do
            velocity = create.element(tabs.aa, "Velocity Warning")
            velocity.drag = create.drag("Velocity Warning", {screen.center.x, screen.size.y*0.3})
            velocity.color = create.color(tabs.aa, 'velocity', {{175,175,255,255}, {220,30,50,255}}, {"Good", "Bad"})

            Features.velocity = velocity
        end

        local stickman = {} do
            stickman = create.element(tabs.aa, "Stickman")
            stickman.color = create.color(tabs.aa, 'stickman', {{255,255,255,200}})
            stickman.def = tabs.aa:checkbox("Only on defensive")


            Features.stickman = stickman
        end

        Features.label2 = create.label(tabs.aa, "Ragebot")


        local logs = {} do
            logs = create.element(tabs.aa, "Ragebot Logs")
            logs.display = tabs.aa:multiselect("\nlogs.display", {"On Screen", "In Console"})
            logs.color = create.color(tabs.aa, 'logs', {{0,0,0,100}}, {"Background"})
            logs.time = tabs.aa:slider("Time\nlogs.time", 5, 50, 30, true, 's', .1)
            logs.used = tabs.aa:checkbox("Used display?")
            logs.used:depend({setup, 'xdadadsadadx'})
            logs.time:depend({logs.display, 'On Screen'})
            logs.display:set_callback(function()
                logs.used:set(true)
            end)
            if not logs.used.value then
                logs.display:set({"On Screen", "In Console"})
            end

            Features.logs = logs
        end

        local marker = {} do
            marker = create.element(tabs.aa, "Shot Marker")

            marker.time = tabs.aa:slider("Time\nmarker.time", 5, 50, 30, true, 's', .1)
            marker.size = tabs.aa:slider("Size\nmarker.size", 3, 10, 5)
            marker.style = tabs.aa:combobox("\nmarker.Style", {"Style: Cross", "Style: Plus"})
            marker.extra = tabs.aa:checkbox("Show Miss Reason")

            Features.marker = marker
        end

        local color = {} do
            color.label = tabs.aa:label('\nmega label color')
            color['hit'] = tabs.aa:label('Hit color', {180, 230, 30, 255})
            color['?'] = tabs.aa:label('? color', {255, 0, 0, 255})
            color['spread'] = tabs.aa:label('Spread color', {255, 200, 0, 255})
            color['prediction error'] = tabs.aa:label('Prediction error color', {255, 125, 125, 255})
            color['unpredicted occasion'] = tabs.aa:label('Unpredicted occasion color', {255, 125, 125, 255})
            color['death'] = tabs.aa:label('Death color', {100, 100, 255, 255})
            color['unregistered shot'] = tabs.aa:label('Unregistered shot color', {100, 100, 255, 255})

            for a,b in pairs(color) do
                b:depend({setup, function()
                    return setup.value == "Ragebot Logs" or setup.value == 'Shot Marker'
                end}, {tab, 'Features'})
            end
            
            Features.color = color
        end

        local tracer = {} do
            tracer = create.element(tabs.aa, "Bullet Tracer")
            tracer.time = tabs.aa:slider("Time\ntracer.time", 5, 50, 20, true, 's', .1)
            tracer.color = create.color(tabs.aa, 'tracer', {{255,255,255,200}})

            Features.tracer = tracer
        end

        local helper = {} do
            helper = create.element(tabs.aa, "Damage Helper")
            helper.note = tabs.aa:label("\aafafff90Note: Draws line if 1-shot to stomach.")
            helper.color = create.color(tabs.aa, 'helper', {{255,255,255,75}})
            helper.label = tabs.aa:label("Lines Positions")
            helper.first = tabs.aa:combobox("\nFirstperson.helper", {"Firstperson: Crosshair", "Firstperson: Upper-Center", "Firstperson: Bottom-Center"})
            helper.third = tabs.aa:combobox("\nThirdperson.helper", {"Thirdperson: Local Player","Thirdperson: Crosshair", "Thirdperson: Upper-Center", "Thirdperson: Bottom-Center"})


            Features.helper = helper
        end

        local hitchance = {} do
            hitchance = create.element(tabs.aa, "Hitchance Modifier")
            local disabled = ('\aC8C8C8C8'..'off ')
            local data = {} do
                data.elements = {
                    "Bind / In Air / No Scope", "Global", "Autosnipers", "SSG 08", "AWP", "R8 Revolver", "Desert Eagle", "Pistol", "Zeus", "Rifle", "Shotgun", "SMG", "Machine gun"
                }
                data.scope = {
                    "Autosnipers", "SSG 08", "AWP"
                }
                data.ex = {[(data.elements[1])] = true}
                data.list = {table.unpack(data.elements)}
                data.numbers = {}
                data.values = {}
                for i, name in pairs(data.elements) do
                    data.numbers[name] = i
                    if name ~= data.elements[1] then
                        data.values[name] = { button = disabled, air = disabled, scope = disabled}
                    end
                end
                for a, b in pairs(data.ex) do
                    data.list[data.numbers[a]] = pui.format('\v'..data.list[data.numbers[a]])
                end
            end

            hitchance.box = tabs.aa:listbox("\nhitchance", data.list)

            local settings = {}
            for a, b in pairs(data.elements) do
                if not data.ex[b] then
                    settings[b] = {}
                    local button,air,scope = {}, {}, {}

                    button.on = tabs.aa:checkbox("Enabled hitchance \vOn Button\n"..b)
                    button.hotkey = tabs.aa:hotkey("\nez"..b, true)
                    button.hitchance = tabs.aa:slider("\nbutton"..b, 0, 100, 50, true, '%')
                    settings[b].button = button

                    air.on = tabs.aa:checkbox("Enabled hitchance \vIn Air\n"..b)
                    air.hitchance = tabs.aa:slider("\nair"..b, 0, 100, 50, true, '%')
                    settings[b].air = air

                    if data.scope[data.numbers[b] - 2] then
                        scope.on = tabs.aa:checkbox("Enabled hitchance \vNo scope\n"..b)
                        scope.hitchance = tabs.aa:slider("\nscope"..b, 0, 100, 50, true, '%')
                        settings[b].scope = scope
                    end 
                    pui.traverse(settings[b], function(element, path)
                        if path[2] ~= 'on' then
                            element:depend({settings[b][path[1]].on, true})
                        else
                            element:set_callback(function(self)
                                data.values[b][path[1]] = (element.value and ('\v'..'on ') or disabled)
                                data.list[data.numbers[b]] = pui.format(data.elements[data.numbers[b]] ..' \aC8C8C8C8~ ' .. data.values[b].button.. data.values[b].air.. (data.scope[data.numbers[b] - 2] and data.values[b].scope or ''))
                                hitchance.box:update(data.list)
                            end, true)
                        end
                    end)
                end
            end
            pui.traverse(settings, function(element, path)
                element:depend({hitchance.box, data.numbers[path[1]] - 1})
            end)

            hitchance.settings = settings
            Features.hitchance = hitchance
        end

        Features.label3 = create.label(tabs.aa, "Other")

        local animations = {} do
            animations = create.element(tabs.aa, "Animations")

            animations.ground = tabs.aa:combobox('On-Ground', {"Default", "Never slide", "Always slide", "Jitter", "Moonwalk"})
            animations.note = tabs.aa:label("\aCAB02AC8"..'"Jitter" works as an anti-aim')
                :depend({animations.ground, "Jitter"})
            animations.air = tabs.aa:combobox('In-Air', {"Default", "Static", "Moonwalk"})
            animations.extra = tabs.aa:multiselect('Extra', {"Landing Pitch", "Disable Move Lean"})

            Features.animations = animations
        end

        -- local shared = {} do
        --     shared = create.element(tabs.aa, "Shared Logo")

        --     shared.box = tabs.aa:listbox("\nshared.logo", db.icons)

        --     Features.shared = shared
        -- end

        -- local quake = {} do
        --     quake = create.element(tabs.aa, "Quake Sounds")

        --     quake.image = tabs.aa:checkbox("Show Image")
        --     quake.volume = tabs.aa:slider("Volume", 0, 100, 50, true, '%')


        --     Features.quake = quake
        -- end

        local console = {} do
            console = create.element(tabs.aa, "Console Filter")

            Features.console = console
        end
        
        local clantag = {} do
            clantag = create.element(tabs.aa, "Clantag")

            Features.clantag = clantag
        end

        local trashtalk = {} do
            trashtalk = create.element(tabs.aa, "Trashtalk")
            trashtalk.event = tabs.aa:multiselect("\ntrashtalk.event", {"On Kill", "On Death"})
            trashtalk.used = tabs.aa:checkbox("Used elements? trashtalk")
            trashtalk.used:depend({setup, 'xdadadsadadx'})

            if not trashtalk.used.value then
                pui.traverse(trashtalk, function(element, path)
                    if path[1] == 'event' then
                        element:set({"On Kill", "On Death"})
                    end
                end)
            end

            Features.trashtalk = trashtalk
        end

        menu.Features = Features
    end

    local Antiaims = {} do

        local settings = {} do
            settings.cond = tabs.fl:combobox("\vCondition", condition_list, nil, false)

            Antiaims.settings = settings
        end

        local other = {} do
            other.fl_disabler = tabs.aa:multiselect("Fake Lag Disablers", {"Not moving", "Crouch Move"})
            other.space = tabs.aa:label('\nlabel4')
            other.avoid_backstab = tabs.aa:checkbox('Avoid Backstab')
            other.ladder = tabs.aa:checkbox('Fast Ladder')
            -- other.unsafe = tabs.aa:checkbox('Unsafe Exploit Charge')

            Antiaims.other = other
        end

        local hotkeys = {} do
            hotkeys.space = tabs.aa:label('\nlabel3')
            hotkeys.edge = tabs.aa:hotkey('Edge Yaw')
            hotkeys.fs = tabs.aa:hotkey('Freestanding')
            hotkeys.fs_disablers = tabs.aa:multiselect("Disablers \nFS", {"Yaw Jitter", "Body Yaw"})
            hotkeys.space1 = tabs.aa:label('\nlabel2')
            hotkeys.left = tabs.aa:hotkey('Manual \v<\r Left')
            hotkeys.right = tabs.aa:hotkey('Manual \v>\r Right')
            hotkeys.forward = tabs.aa:hotkey('Manual \v^\r Forward')
            hotkeys.space2 = tabs.aa:label('\nlabel2')

            Antiaims.hotkeys = hotkeys
        end

        local t1,t2,t3 = {}, {}, {}
        for i=-180, 180 do
            t1[i] = i..' max'
        end
        for i=-180, 180 do
            t2[i] = i..' min'
        end
        for i=0, 50 do
            t3[i] = i*.1 ..' °/s'
        end

        local other2 = {} do
            -- other2.defensive = tabs.other:checkbox('Disable Defensive AA')
            other2.defensive = tabs.other:multiselect('Disable Defensive Features', {"Def. Flick", "Def. AA", "Force Def."})
            other2.flick = tabs.other:checkbox('Defensive Flick', 0X00)

            local aa = {
                disablers = tabs.other:multiselect("Disablers", {"Body Yaw", "Yaw Jitter"}),

                pitch = tabs.other:combobox("Pitch\nfl d_pitch", {"None", "Random", "Custom", "Progressive"}),
                pitch_val = tabs.other:slider("\nfl d_pitch_val", -89, 89, 0, true, '°', 1, {[-89] = "Up", [-45] = "Semi-Up", [0] = "Zero", [45] = "Semi-Down", [89] = "Down"}),    
                pitch_speed = tabs.other:slider("\nfl d_pitch_speed", 0, 50, 10, true, '', 0.1, t3),
                pitch_min = tabs.other:slider("\nfl d_pitch_min", -89, 89, -89, true, '°', 1, t2),
                pitch_max = tabs.other:slider("\nfl d_pitch_max", -89, 89, 89, true, '°', 1, t1),

                yaw = tabs.other:combobox("Yaw\nfl  d_yaw", {"None", "Sideways", 'Sideways 45', "Spin", "Random", "Custom", "Yaw Opposite", "Progressive", "Yaw Side"}),
                yaw_val = tabs.other:slider("\nfl d_yaw_val", -180, 180, 0, true, '°', 1, {[-180] = 'Forward', [0] = "Backward", [180] = "Forward"}),
                yaw_invert = tabs.other:hotkey("Inverter"),
                yaw_speed = tabs.other:slider("\nfl d_yaw_speed", 0, 50, 10, true, '', 0.1, t3),
                yaw_min = tabs.other:slider("\nfl d_yaw_min", -180, 180, -180, true, '°', 1, t2),
                yaw_max = tabs.other:slider("\nfl d_yaw_max", -180, 180, 180, true, '°', 1, t1),

            }
            pui.traverse(aa, function(element, path)
                element:depend({other2.flick, true})
            end)

            aa.pitch_val:depend({aa.pitch, 'Custom'})
            aa.yaw_val:depend({aa.yaw, "Custom"})
            aa.pitch_speed:depend({aa.pitch, 'Progressive'})
            aa.pitch_min:depend({aa.pitch, 'Progressive'})
            aa.pitch_max:depend({aa.pitch, 'Progressive'})
            aa.yaw_invert:depend({aa.yaw, "Custom"})
            aa.yaw_speed:depend({aa.yaw, "Progressive", "Spin"})
            aa.yaw_min:depend({aa.yaw, 'Progressive'})
            aa.yaw_max:depend({aa.yaw, 'Progressive'})
            other2.flick_aa = aa
            Antiaims.other2 = other2
        end

        local xd do
            Antiaims.label = tabs.fl:label('\nlabel1')

            Antiaims.label2 = tabs.fl:label('\nlabel2')
            Antiaims.default = tabs.fl:checkbox("GS", nil, false)
            Antiaims.megabutton = tabs.fl:button("Setup \vOther\r settings")

            tab:depend({Antiaims.default, false})
            tab_label:depend({Antiaims.default, false})
            Antiaims.default:depend({tab, 'fwefwefw'})

            Antiaims.default:set_callback(function(self)
                for a,t in pairs(refs) do
                    if a ~= 'aa' then
                        for name,el in pairs(t) do
                            el:set_visible(self.value)
                        end
                    end
                end
                refs.aa.fs:set_visible(self.value)
            end, true)

            Antiaims.megabutton:set_callback(function()
                Antiaims.default:set(not Antiaims.default:get())
            end)
            xd = {
                ['megabutton'] = true,
                ['label'] = true,
                ['other'] = 1,
                ['hotkeys'] = 1,
            }
        end

        local defensive_max = 13
        local max_angle = 180

        local builder = {} do
            local xd2 = {table.unpack(condition_list)}
            table.remove(xd2, 1)
            table.remove(xd2, 10)
            for i, name in pairs(condition_list) do
                builder[name] = {}

                pui.macros.x = '\n'..name


                builder[name].enabled = (name ~= condition_list[1] and name ~= condition_list[10]) and tabs.aa:checkbox("Enabled - \v"..name) or nil
                builder[name].conditions = name == condition_list[11] and tabs.aa:multiselect("Conditions", (xd2)) or nil
                builder[name].weapons = name == condition_list[11] and tabs.aa:multiselect("\nWeapons", {
                    "Knife", 
                    "Zeus", 
                    "Height Advantage"
                }) or nil
                builder[name].label_en = tabs.aa:label("\nen label")
                builder[name].yaw = {
                    base = tabs.aa:combobox("Yaw Base", (name == condition_list[10] and {"Local view", "At targets"} or {"At targets", "Local view"})),
                    global = name ~= condition_list[10] and tabs.aa:slider("Global Yaw\f<x>", -max_angle, max_angle, 0, true, '°') or nil,
                    left = name ~= condition_list[10] and tabs.aa:slider("Left & Right Yaw\f<x>", -max_angle, max_angle, 0, true, '°') or nil,
                    right = name ~= condition_list[10] and tabs.aa:slider("\nright yaw\f<x>", -max_angle, max_angle, 0, true, '°') or nil,
                }
                builder[name].label_yaw = tabs.aa:label("\nyaw label")

                builder[name].jitter = {
                    type = tabs.aa:combobox("Yaw Jitter\f<x>", {
                        "Off", 
                        "Offset", 
                        "Center", 
                        "Random", 
                        "Skitter", 
                        "3-Way", 
                        "5-Way", 
                    }),
                    mode = tabs.aa:combobox("\njitter mode\f<x>", {
                        "Static", "Switch", "Random", "Spin"
                    }),
                    value = tabs.aa:slider("\f<x>jitter value", -max_angle, max_angle, 0, true, '°'),
                    value2 = tabs.aa:slider("\f<x>jitter value2", -max_angle, max_angle, 0, true, '°'),
                    ways = (function()
                        local el = {}
                        for i=1, 5 do
                            el[i] = tabs.aa:slider("\f<x>way" .. i, -max_angle, max_angle, 0, true, '°')
                        end
                        return el
                    end)(),
                    rand = tabs.aa:slider("Randomization\f<x>", 0, max_angle, 0, true, '°', 1, {[0] = 'Off'})
                }

                local t = {['Off'] = true, ['3-Way'] = true, ['5-Way'] = true}
                builder[name].jitter.mode:depend({builder[name].jitter.type, function()
                    return not t[builder[name].jitter.type.value]
                end})
                builder[name].jitter.value:depend({builder[name].jitter.type, function()
                    return not t[builder[name].jitter.type.value]
                end})
                builder[name].jitter.value2:depend({builder[name].jitter.mode, "Static", true}, {builder[name].jitter.type, function()
                    return not t[builder[name].jitter.type.value]
                end})
                for i=1, 5 do
                    builder[name].jitter.ways[i]:depend({builder[name].jitter.type, function()
                        return i<4 and builder[name].jitter.type.value == '3-Way' or builder[name].jitter.type.value == '5-Way'
                    end})
                end
                builder[name].jitter.rand:depend({builder[name].jitter.type, "Off", true})
                
                builder[name].body = {
                    yaw = tabs.aa:combobox('Body Yaw\f<x>', {"Off", "Static", "Opposite", "Jitter"}),
                    side = tabs.aa:slider("\f<x> side", 0,1,0, true, nil, 1, {[0] = "Left", [1] = "Right"}),
                    delay = {
                        mode = tabs.aa:combobox("\ndelay mode\f<x>", {"Static", "Switch"}),
                        delay = tabs.aa:slider("Delay\f<x>", 1, 12, 1, true, 't', 1, {[1] = 'Default'}),
                        left = tabs.aa:slider("Left ticks\f<x>", 1, 12, 1, true, 't', 1, {[1] = 'Default'}),
                        right = tabs.aa:slider("Right ticks\f<x>", 1, 12, 1, true, 't', 1, {[1] = 'Default'}),
                        switch = tabs.aa:slider("Switch ticks\f<x>", 0, 50, 0, true, 't', 1, {[0] = 'Off'}),
                    }
                }
                builder[name].body.side:depend({builder[name].body.yaw, "Static"})
                for a,b in pairs(builder[name].body.delay) do
                    b:depend({builder[name].body.yaw, "Jitter"}, a ~= 'mode' and {builder[name].body.delay.mode, a == 'delay' and "Static" or "Switch"})
                end
                builder[name].label_def = tabs.aa:label("\ndef label")
                if name ~= "Fake Lag" then
                    builder[name].defensive = {
                        force = tabs.aa:checkbox("Force Defensive\f<x>"),
                        enabled = tabs.aa:checkbox("Enabled \v" .. name ..  " \rDefensive AA\f<x>"),
                        enabled_ = name ~= "Default" and tabs.aa:label("\aFFFFFF4E- Using settings from "..condition_list[1].." Condition\f<x>") or nil,
                        override = name ~= "Default" and tabs.aa:checkbox("Override \v" .. name ..  " \rDefensive AA\f<x>") or nil,
                        override_ = tabs.aa:label("\aFF4E4EFF- DEFENSIVE AA DISABLED\f<x>"),

                        settings = {
                            duration = tabs.aa:slider('Duration \f<x>', 2, defensive_max, 13, true, 't', 1, {[13] = "Max"}),
                            disablers = tabs.aa:multiselect("Disablers", {"Body Yaw", "Yaw Jitter"}),

                            pitch = tabs.aa:combobox("Pitch\f<x> d_pitch", {"None", "Random", "Custom", "Progressive"}),
                            pitch_val = tabs.aa:slider("\f<x>d_pitch_val", -89, 89, 0, true, '°', 1, {[-89] = "Up", [-45] = "Semi-Up", [0] = "Zero", [45] = "Semi-Down", [89] = "Down"}),      
                            pitch_speed = tabs.aa:slider("\nd d_pitch_speed", 0, 50, 10, true, '', 0.1, t3),
                            pitch_min = tabs.aa:slider("\nd d_pitch_min", -89, 89, -89, true, '°', 1, t2),
                            pitch_max = tabs.aa:slider("\nd d_pitch_max", -89, 89, 89, true, '°', 1, t1),
                            yaw = tabs.aa:combobox("Yaw\f<x> d_yaw", {"None", "Sideways", 'Sideways 45', "Spin", "Random", "Custom", "Yaw Opposite", "Progressive", "Yaw Side"}),
                            yaw_val = tabs.aa:slider("\f<x>d_yaw_val", -180, 180, 0, true, '°', 1, {[-180] = 'Forward', [0] = "Backward", [180] = "Forward"}),
                            yaw_speed = tabs.aa:slider("\nd d_yaw_speed", 0, 50, 10, true, '', 0.1, t3),
                            yaw_min = tabs.aa:slider("\nd d_yaw_min", -180, 180, -180, true, '°', 1, t2),
                            yaw_max = tabs.aa:slider("\nd d_yaw_max", -180, 180, 180, true, '°', 1, t1),
                        }
                    }
                    for n,ref in pairs(builder[name].defensive.settings) do
                        ref:depend({builder[name].defensive.enabled, true})
                        if name ~= condition_list[1] then
                            ref:depend({builder[name].defensive.override, true})
                        end
                    end
                    if name ~= condition_list[1] then 
                        builder[name].defensive.override:depend({builder[name].defensive.enabled, true})
                        builder[name].defensive.enabled_:depend({builder[name].defensive.enabled, true}, {builder[name].defensive.override, false})
                    end
                    builder[name].defensive.override_:depend({other2.defensive, true}, {builder[name].defensive.enabled, true})
                    builder[name].defensive.settings.pitch_val:depend({builder[name].defensive.settings.pitch, 'Custom'})
                    builder[name].defensive.settings.yaw_val:depend({builder[name].defensive.settings.yaw, "Custom"})
                    builder[name].defensive.settings.pitch_speed:depend({builder[name].defensive.settings.pitch, 'Progressive'})
                    builder[name].defensive.settings.pitch_max:depend({builder[name].defensive.settings.pitch, 'Progressive'})
                    builder[name].defensive.settings.pitch_min:depend({builder[name].defensive.settings.pitch, 'Progressive'})
                    builder[name].defensive.settings.yaw_speed:depend({builder[name].defensive.settings.yaw, "Progressive", "Spin"})
                    builder[name].defensive.settings.yaw_min:depend({builder[name].defensive.settings.yaw, "Progressive"})
                    builder[name].defensive.settings.yaw_max:depend({builder[name].defensive.settings.yaw, "Progressive"})
                end
                builder[name].label_def2 = tabs.aa:label("\ndef label2")

                builder[name].export = tabs.aa:button("Export \v"..name)
                builder[name].import = tabs.aa:button("Import \v"..name)
                builder[name].export:set_callback(function(self)
                    local config = pui.setup(builder[name])

                    clipboard.set(base64.encode( json.stringify(config:save()) ))
                    client.exec('playvol buttons\\button18 0.5')
                    utils.printc(pui.format("\f<r>[\f<ez>rinnegan\f<r>] ~ Exported condition \f<ez>" .. name))
                end)
                builder[name].import:set_callback(function(self)
                    local config = pui.setup(builder[name])

                    config:load(json.parse(base64.decode(clipboard.get())))
                    client.exec('playvol buttons\\button17 0.5')
                    utils.printc(pui.format("\f<r>[\f<ez>rinnegan\f<r>] ~ Imported config for \f<ez>" .. name ..'\f<r> condition'))
                end)
            end

            pui.traverse(builder, function(element, path)
                element:depend({settings.cond, path[1]})
                if path[1] ~= condition_list[1] and path[1] ~= condition_list[10] and path[2] ~= 'enabled' then
                    element:depend({builder[path[1]].enabled, true})
                end
            end)

            Antiaims.builder = builder
        end

        pui.traverse(Antiaims, function(element, path)
            if not xd[path[1]] then
                element:depend({Antiaims.default, false})
            elseif xd[path[1]] == 1 then
                element:depend({Antiaims.default, true})
            end
        end)

        menu.Antiaims = Antiaims
    end

    client.set_event_callback('post_config_load', function()
        setup:set("None")
    end)

    pui.traverse(menu, function(element, path)
        element:depend({tab, path[1]})
        if path[3] == 'color' then goto skip end
        if path[1] == "Features" and path[3] == 'on' then
            local path2 = menu.Features[path[2]]
            pui.traverse(path2, function(el, path3)
                local el = path2
                for _, name in pairs(path3) do
                    el = el[name]
                end
                el:depend({setup, function()
                    return setup.value == path2.on.name:sub(9, #path2.on.name) or (({['disabled'] = true, ['enabled'] = true, ['on'] = true})[path3[1]] and setup.value == 'None')
                end})
            end)
        end
        ::skip::
    end)
end

local Config do
    Config = pui.setup(menu)

    local update_box = function()
        db.configs = {}
        for i, cfgs in pairs(db.db.configs[menu.Home.aa.type.value]) do
            table.insert(db.configs, pui.format('[\v'..i..'\r] ' .. cfgs[1])) 
        end
        menu.Home.aa.box:update(db.configs)
    end update_box()

    local create_config = function(name, cfg)
        name = cfg and name or menu.Home.other.Local.name:get()
        if #name >= 1 then
            table.insert(db.db.configs['Local'], {name, cfg or base64.encode(json.stringify(Config:save())) } )
            db.save()
            menu.Home.other.Local.name:set('')
            utils.printc(pui.format("\f<r>[\f<ez>rinnegan\f<r>] ~ \f<ez>"..(cfg and 'Imported' or 'Created').." \f<r>config \f<ez>" .. name))
        end
        update_box()
        menu.Home.aa.box:set(#db.db.configs['Local'] - 1)
    end
    menu.Home.other.Local.create:set_callback(create_config)

    local get_config = function()
        local t = db.db.configs['Local'][menu.Home.aa.box.value + 1]
        return t[1], t[2]
    end

    menu.Home.aa.delete:set_callback(function()
        local val = menu.Home.aa.box:get()
        utils.printc(pui.format("\f<r>[\f<ez>rinnegan\f<r>] ~ \f<ez>Deleted \f<r>config \f<ez>" .. get_config(val)))

        client.exec('playvol buttons\\button16 0.5')
        table.remove(db.db.configs['Local'], val + 1)
        menu.Home.aa.box:set(0)
        db.save()
        update_box()
    end)

    menu.Home.aa.save:set_callback(function()
        local cfg = base64.encode( json.stringify(Config:save()) )
        db.db.configs['Local'][menu.Home.aa.box.value + 1][2] = cfg
        if menu.Home.other.Local.autoload_save:get("Save") then
            db.db.last.cfg = cfg
        end
        utils.printc(pui.format("\f<r>[\f<ez>rinnegan\f<r>] ~ \f<ez>Updated \f<r>config \f<ez> ".. get_config()))

        client.exec('playvol buttons\\button16 0.5')
        db.save()
    end)

    menu.Home.aa.export:set_callback(function()
        local name, cfg = get_config()
        local text = string.format('Rinnegan::%s::%s', name, cfg)
        client.exec('playvol buttons\\button18 0.5')
        clipboard.set(text)
        utils.printc(pui.format("\f<r>[\f<ez>rinnegan\f<r>] ~ \f<ez>Exported \f<r>config \f<ez>" .. name))

    end)
    
    local load_config = function(self, cfg)
        local name, config = get_config()
        local decrypted = json.parse( base64.decode(config) )
        Config:load(decrypted, self.name == "Load AA" and "Antiaims" or nil)
        drag.on_config_load()
        utils.printc(pui.format("\f<r>[\f<ez>rinnegan\f<r>] ~ \f<ez>Loaded"..(self.name == "Load AA" and " antiaim" or '').." \f<r>config \f<ez>" .. name))
        client.exec('playvol buttons\\button17 0.5')
        if menu.Home.other.Local.autoload_save:get("Load") then
            db.db.last.cfg = base64.encode( json.stringify(Config:save()) )
        end
        db.save()
    end

    menu.Home.other['Local'].import:set_callback(function()
        local text = clipboard.get()
        local name, config = text:match("Rinnegan::([%s%S]+)::([%s%S]+)")
        if not name or not config then return end
        create_config(name,config)
        load_config(menu.Home.aa.load)
    end)
    
    menu.Home.aa.load:set_callback(load_config)
    menu.Home.aa.loadaa:set_callback(load_config)
    if db.db.last.on and db.db.last.cfg then
        local decrypted = json.parse( base64.decode(db.db.last.cfg) )
        Config:load(decrypted)
        utils.printc(pui.format("\f<r>[\f<ez>rinnegan\f<r>] ~ \f<ez>Loaded \f<r>last saved config"))
        
        client.exec('playvol buttons\\button17 0.5')
    end

    defer(function()
        if db.db.last.on and menu.Home.other.Local.autoload_save:get("Shutdown") then
            db.db.last.cfg = base64.encode( json.stringify(Config:save()) )
            db.save()
        end
    end)
end

local lp do
    lp = {}
    lp.state = "Standing"
    lp.manual = nil
    lp.in_score = false
    lp.scoped = false
    lp.zoom = 0
    lp.entity = nil
    -- lp.tickbase_shifting = 0
    lp.weapon = nil
    lp.flicking = false
    lp.exploit = ''

    lp.on_ground = false
    lp.moving = false
    lp.crouch = false

    local height_advantage = function()
        local origin = vector(entity.get_origin(lp.entity))
        local threat = client.current_threat()
        if not threat then return false end
        local threat_origin = vector(entity.get_origin(threat))
        local height_to_threat = origin.z-threat_origin.z
        return height_to_threat > 50
    end

    local update_state = function(e)
        lp.flicking = menu.Antiaims.other2.flick.value and menu.Antiaims.other2.flick:get_hotkey() and not menu.Antiaims.other2.defensive:get("Def. Flick")
        lp.exploit = refs2.fd:get() and 'fd' or refs2.dt.value and refs2.dt:get_hotkey() and 'dt' or refs.other.osaa.value and refs.other.osaa:get_hotkey() and 'osaa' or ''
        lp.entity = entity.get_local_player()
        -- lp.tickbase_shifting = antiaim_funcs.get_tickbase_shifting()

        local flags = entity.get_prop(lp.entity, "m_fFlags")
        local velocity = vector(entity.get_prop(lp.entity, "m_vecVelocity"))
    
        lp.on_ground = bit.band(flags, 1) ~= 0 and e.in_jump == 0
        lp.crouch = entity.get_prop(lp.entity, "m_flDuckAmount") > 0.9
        lp.moving = math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y) + (velocity.z * velocity.z)) > 5

        lp.in_score = e.in_score == 1
        lp.scoped = entity.get_prop(lp.entity, 'm_bIsScoped') == 1
        lp.weapon = entity.get_player_weapon(lp.entity)
        lp.zoom = lp.weapon and entity.get_prop(lp.weapon, 'm_zoomLevel') or 0

        local state = (function()
            if lp.manual then return condition_list[10] end
            if menu.Antiaims.builder[condition_list[12]].enabled:get() and #entity.get_players(true) == 0 then return condition_list[12] end
            if not (refs2.dt.value and refs2.dt.hotkey:get())
            and not (refs.other.osaa.value and refs.other.osaa.hotkey:get())
            and refs.fl.enabled.value and refs.fl.enabled.hotkey:get() then return condition_list[9] end
            if lp.on_ground then
                if lp.crouch then return lp.moving and condition_list[6] or condition_list[5]
                else if lp.moving then 
                    return e.in_speed == 1 and condition_list[4] or condition_list[3]
                    else return condition_list[2] end 
                end
            else return lp.crouch and condition_list[8] or condition_list[7]
            end
        end)()
        
        local csgoweapon = csgo_weapons(lp.weapon)
        local safehead
        if csgoweapon and menu.Antiaims.builder[condition_list[11]].conditions:get(state) then
            local work = (
                csgoweapon.is_knife and menu.Antiaims.builder[condition_list[11]].weapons:get("Knife") or 
                csgoweapon.is_taser and menu.Antiaims.builder[condition_list[11]].weapons:get("Zeus") or
                menu.Antiaims.builder[condition_list[11]].weapons:get("Height Advantage") and height_advantage()
            )
            safehead = work and condition_list[11] or false
        end
        lp.state = safehead or state
    end
    client.set_event_callback('setup_command', update_state)
    client.set_event_callback("level_init", function()
        lp.entity = nil
    end)
end

local watermark do 

    local fps,last,avg_fps = math.floor(1.0 / globals.frametime()),globals.curtime(),0
    local last2 = last
    local update
    local reset

    update = function()
        client.delay_call(1, update)

        fps =  math.floor(avg_fps)
    end update()

    reset = function()
        client.delay_call(10, reset)
        avg_fps = 0
    end reset() 

    local render = drag.register(menu.Features.watermark.drag, vector(330, 25), "watermark", function(self)

        local text do
            local new_frame = 1.0 / math.max(0.0001, globals.frametime())
            avg_fps = avg_fps <= 0.0 and new_frame or (avg_fps * 0.9 + new_frame * 0.1)

            local ping = string.format('%.0f', client.latency()*1000)
        
            local hours, minutes = client.system_time()
            local time = string.format("%02d:%02d", hours,minutes)

            local custom = menu.Features.watermark.custom:get()

            text = '  $  rinnegan / '..version[1] ..'  $  '..
            (menu.Features.watermark.elements:get("Nickname") and (custom ~= '' and custom or (_USER_NAME or 'admin'))..'  $  ' or '')..
            (menu.Features.watermark.elements:get("FPS") and fps..' fps  $  ' or '')..
            (menu.Features.watermark.elements:get("Ping") and ping..' ms  $  ' or '')..
            (menu.Features.watermark.elements:get("Time") and time..'  $  ' or '')

        end

        local measure = vector(renderer.measure_text('d', text))
        self.position.y = math.floor(menu.Features.watermark.lock.value == "None" and self.position.y or string.match(menu.Features.watermark.lock.value, 'Upper') and 10 or screen.size.y-measure.y-10)
        self.position.x = math.floor( menu.Features.watermark.lock.value == "None" and self.position.x or
            (menu.Features.watermark.lock.value == 'Upper-Right' or menu.Features.watermark.lock.value == 'Bottom-Right') and screen.size.x - measure.x - 20 or
            (menu.Features.watermark.lock.value == 'Upper-Center' or menu.Features.watermark.lock.value == 'Bottom-Center') and screen.center.x - measure.x * 0.5 or 20
        )

        self.size.x = measure.x
        self.size.y = measure.y+6

        local w = colors['watermark']["Background"]
        local t = colors['watermark']["Text"]

        utils.rectangle(self.position.x,self.position.y, self.size.x, self.size.y, w.r,w.g,w.b,w.a, 5)
        renderer.text(self.position.x, self.position.y + 2, t.r,t.g,t.b,math.max(t.a, 75), 'd', 0, menu.Features.watermark.candy.value and gradient.animated_gradient_text(text, gradient.table, 20/#gradient.table, 1) or text)
    end, nil, false)

    client.set_event_callback('paint', function()
        render:update()
    end)
end

local hitchance do
    local custom = {
        ['G3SG1 / SCAR-20'] = "Autosnipers", 
    }
    local self = menu.Features.hitchance
    local setup = function()
        refs2.hc:override()
        if not lp.entity or not entity.is_alive(lp.entity) then return end
        local weapon = refs2.weapon:get()
        local a = self.settings[(custom[weapon] or weapon)]
        local b = a.button.hotkey:get() and a.button.on.value and 'button' or a.air.on.value and not lp.on_ground and 'air' or a.scope and a.scope.on.value and not lp.scoped and 'scope' or nil
        if not b then hitchance = false return end
        hitchance = {b, a[b].hitchance.value}

        client.delay_call(0,function()
            refs2.hc:override(a[b].hitchance.value)
        end)
    end
    menu.Features.hitchance.on:set_event('setup_command', setup)
    menu.Features.hitchance.on:set_callback(function()
        hitchance = false
        refs2.hc:override()
    end)
end

local crosshair do
    crosshair = { --{x, alpha, y}
        {0, 1,0},
        {0, 1,0, 0},
        {0, 0,0},
        {0, 0,0},
        {0, 0,0},
        {0, 0,0},
        {0, 0,0},
        {0, 0,0},
        {0, 0,0},
        {0, 0,0},
        {0, 0,0},
    }
    local flags = '-cd'
    local prev = lp.state
    local transparency = 0
    local render = function()
        if not lp.entity or not entity.is_alive(lp.entity) then return end
        local weapon2 = entity.get_player_weapon(lp.entity)
        if not weapon2 then return end
        local weapon = csgo_weapons(weapon2)
        if not weapon then return end
        local game_rules = entity.get_game_rules()
        if not game_rules then return end
        local m_gamePhase = entity.get_prop(game_rules, 'm_gamePhase')
        local NextPhase = entity.get_prop(game_rules, 'm_timeUntilNextPhaseStarts')
        transparency = utils.lerp(transparency, (weapon.is_grenade or lp.in_score or m_gamePhase == 5 or NextPhase ~= 0) and 0.5 or 1, 0.03)

        local version1 = colors['crosshair']['Version']:clone()
        version1.a = version1.a * transparency
        local rin = colors['crosshair']['Rinnegan']:clone()
        rin.a = math.max(127, rin.a * transparency)
        local cond = colors['crosshair']['Conditions']:clone()
        cond.a = cond.a * transparency

        menu.Features.crosshair.settings['Rinnegan'].container.candy:get()
        local elements = {
            -- {"Rinnegan", true, gradient.animated_gradient_text(text, gradient.table, (#gradient.table/5)/#gradient.table)},
            {"Rinnegan", true, 
            (menu.Features.crosshair.settings['Rinnegan'].container.candy.value and "rinnegan ["..version[1].."]" or ("\a"..utils.to_hex(rin).."rinnegan \a"..utils.to_hex(version1) .."["..version[1].."]"))},
            {"Conditions", true, menu.Features.crosshair.settings['Conditions'].container.candy.value and lp.state or"\a"..utils.to_hex(cond)..lp.state},
            {"Double Tap", refs2.dt.value and refs2.dt:get_hotkey()},
            {"Hide Shots", refs.other.osaa.value and refs.other.osaa:get_hotkey()},
            {"Min. Damage", refs2.mdmg:get() and refs2.mdmg:get_hotkey()},
            {"Hitchance", hitchance and hitchance[1] == 'button'},
            {"Body Aim", refs2.baim:get()},
            {"Safe Points", refs2.safe:get()},
            {"Ping Spike", refs2.ping.value and refs2.ping:get_hotkey()},
            {"Freestanding", menu.Antiaims.hotkeys.fs:get()},
            {"Flicking", lp.flicking},
        }
        for i=2, #elements do
            local name = elements[i][1]
            elements[i][3] = i == 2 and elements[i][3] or menu.Features.crosshair.settings[elements[i][1]].container.name:get() == '' and hard["crosshair"].names[elements[i][1]] or menu.Features.crosshair.settings[elements[i][1]].container.name:get()
            elements[i][2] = elements[i][2] and menu.Features.crosshair.settings[elements[i][1]].on.value
        end
        local y_add = 20
        
        do
            for i, table in pairs(crosshair) do
                table[2] = utils.lerp(table[2], elements[i][2] and transparency or 0, 0.03)

                if table[2] > 0 then 
                    local text = elements[i][3]:upper()
                    local measure = vector(renderer.measure_text(flags, text))
                    table[3] = utils.lerp(table[3], elements[i][2] and measure.y or 0, 0.03)
                    table[1] = utils.lerp(table[1], elements[i][2] and lp.scoped and (measure.x+20)/2 or 0, 0.035)
                    local c = colors['crosshair'][elements[i][1]]
                    renderer.text(screen.center.x + math.floor(table[1]), screen.center.y + y_add, 
                    c.r,c.g,c.b,c.a * table[2], flags, 0, 
                    menu.Features.crosshair.settings[elements[i][1]].container.candy:get() and gradient.animated_gradient_text(text, gradient.table, (#gradient.table/5)/#gradient.table, table[2]) or text)
                    y_add = y_add + table[3]
                end
            end
        end
    end

    menu.Features.crosshair.on:set_event('paint', render)
end

local damage do
    local alpha = 0
    damage = 100
    
    local render = drag.register(menu.Features.damage.drag, vector(30, 20), "damage", function(self)
        if not lp.entity or not entity.is_alive(lp.entity) then return end
        
        alpha = utils.lerp(alpha, menu.Features.damage.display.value == "Display: Always On" and 1 
            or refs2.mdmg:get() and refs2.mdmg:get_hotkey() and 1 
            or (menu.Features.damage.display.value == "Display: Always On (50%)" and 0.5 or 0), 
            0.02)

        local cur_dmg = ( (refs2.mdmg:get() and refs2.mdmg:get_hotkey()) or menu.Features.damage.display.value == "Display: On Hotkey" and menu.Features.damage.animation.value == "Animation: Instant") and refs2.mdmg2.value or refs2.dmg.value
        
        damage = menu.Features.damage.animation.value == "Animation: Instant" and cur_dmg or utils.lerp(damage, cur_dmg, 0.035)

        if alpha > 0 then
            local c = colors['damage']['Color']
            renderer.text(self.position.x+self.size.x/2, self.position.y + self.size.y/2, c.r,c.g,c.b,c.a * alpha, 'dc'..(menu.Features.damage.font.value == "Font: Default" and '' or '-'), 0, string.format('%.0f', damage))
        end
    end)
    menu.Features.damage.on:set_event('paint', function()
        render:update()
    end)

end

local scope do
    local offset = 0
    local length = 0
    local alpha = 0
    local currentAngle

    local function gradient_line(x1, y1, x2, y2, r1, g1, b1, a1, r2, g2, b2, a2, segments)
        local step = 1 / segments
        for i = 0, segments - 1 do
            local t1, t2 = i * step, (i + 1) * step
            local r = r1 + (r2 - r1) * t1
            local g = g1 + (g2 - g1) * t1
            local b = b1 + (b2 - b1) * t1
            local a = a1 + (a2 - a1) * t1
    
            local x_start = x1 + (x2 - x1) * t1
            local y_start = y1 + (y2 - y1) * t1
            local x_end = x1 + (x2 - x1) * t2
            local y_end = y1 + (y2 - y1) * t2
    
            renderer.line(x_start, y_start, x_end, y_end, r, g, b, a)
        end
    end
    
    local function rotate(x, y, cx, cy, angle)
        local rad = math.rad(angle)
        local cosAngle = math.cos(rad)
        local sinAngle = math.sin(rad)
        local dx = x - cx
        local dy = y - cy
        return cx + dx * cosAngle - dy * sinAngle, cy + dx * sinAngle + dy * cosAngle
    end

    local render = function()
        refs2.scope:override(false)
        if not lp.entity or not entity.is_alive(lp.entity) then return end
    
        offset = utils.lerp(offset, lp.scoped and menu.Features.scope.gap.value or 0, 0.03)
        length = utils.lerp(length, lp.scoped and menu.Features.scope.length.value or 0, 0.03)
        alpha = utils.lerp(alpha, lp.scoped and 1 or 0, 0.02)
    
        if offset > 0 and length > 0 then
            local c = colors['scope']['Color']
            
            if menu.Features.scope.style.value == "Style: Plus" then
                renderer.gradient(screen.center.x, screen.center.y + offset, 1, length, c.r, c.g, c.b, c.a * alpha, c.r, c.r, c.r, 0, false)
                renderer.gradient(screen.center.x + 1, screen.center.y - offset, -1, -length, c.r, c.g, c.b, c.a * alpha, c.r, c.r, c.r, 0, false)
                renderer.gradient(screen.center.x - offset, screen.center.y + 1, -length, -1, c.r, c.g, c.b, c.a * alpha, c.r, c.r, c.r, 0, true)
                renderer.gradient(screen.center.x + offset, screen.center.y, length, 1, c.r, c.g, c.b, c.a * alpha, c.r, c.r, c.r, 0, true)
            
            elseif menu.Features.scope.style.value == "Style: Cross" then
                local targetAngle = alpha * menu.Features.scope.dalbaeb.value  -- Преобразуем alpha в угол
                -- local targetAngle = alpha * globals.framecount()  -- Преобразуем alpha в угол
                currentAngle = utils.lerp(currentAngle or targetAngle, targetAngle, 0.05)
    

                
                local hihihaha = (menu.Features.scope.dalbaeb2.value and -1 or 1)
                offset = math.max(1, offset)
                local x1, y1 = screen.center.x + offset, screen.center.y + offset 
                local x2, y2 = screen.center.x + offset + length, screen.center.y + offset + length
                x2, y2 = rotate(x2, y2, screen.center.x, screen.center.y, currentAngle)
                x1, y1 = rotate(x1, y1, screen.center.x, screen.center.y, currentAngle * hihihaha)
                gradient_line(x1, y1, x2, y2, c.r, c.g, c.b, c.a * alpha, c.r, c.r, c.r, 0, 10)
    
                x1, y1 = screen.center.x - offset, screen.center.y - offset
                x2, y2 = screen.center.x - offset - length, screen.center.y - offset - length
                x2, y2 = rotate(x2, y2, screen.center.x, screen.center.y, currentAngle)
                x1, y1 = rotate(x1, y1, screen.center.x, screen.center.y, currentAngle * hihihaha)
                gradient_line(x1, y1, x2, y2, c.r, c.g, c.b, c.a * alpha, c.r, c.r, c.r, 0, 10)
    
                x1, y1 = screen.center.x + offset, screen.center.y - offset
                x2, y2 = screen.center.x + offset + length, screen.center.y - offset - length
                x2, y2 = rotate(x2, y2, screen.center.x, screen.center.y, currentAngle)
                x1, y1 = rotate(x1, y1, screen.center.x, screen.center.y, currentAngle * hihihaha)
                gradient_line(x1, y1, x2, y2, c.r, c.g, c.b, c.a * alpha, c.r, c.r, c.r, 0, 10)
    
                x1, y1 = screen.center.x - offset, screen.center.y + offset
                x2, y2 = screen.center.x - offset - length, screen.center.y + offset + length
                x2, y2 = rotate(x2, y2, screen.center.x, screen.center.y, currentAngle)
                x1, y1 = rotate(x1, y1, screen.center.x, screen.center.y, currentAngle * hihihaha)
                gradient_line(x1, y1, x2, y2, c.r, c.g, c.b, c.a * alpha, c.r, c.r, c.r, 0, 10)
            end
        end
    end
    
    

    menu.Features.scope.on:set_event('paint', render)
    menu.Features.scope.on:set_event('paint_ui', function()
        refs2.scope:override(true)
    end)
    menu.Features.zoom.on:set_callback(function(self)
        refs2.scope:set_enabled(not self.value)
        if not self.value then 
            refs2.scope:override()
        end
    end)
end

local zoom do
    local val = 0
    local animation = function()
        -- local button = (menu.Features.zoom.button:get() and menu.Features.zoom.third.value*0.5 or 0)
        -- local slider = menu.Features.zoom[( (menu.Features.zoom.mode.value == 'Mode: Single' and 'first') or lp.zoom == 1 and 'first' or 'second')].value*0.5
        -- val = utils.lerp(val, lp.entity and entity.is_alive(lp.entity) and (lp.scoped and (slider + (menu.Features.zoom.stack.value and button or 0)) or button) or 0, 45, 0.5)
        -- local orig = refs2.fov:get_original()
        -- local orig = 
        -- refs2.fov:override(math.max(orig - val,orig - math.floor(val)))
        -- refs2.zoom:override(0)
        
        local distance = menu.Features.zoom.distance.value
        local slider = not lp.scoped and 0 or menu.Features.zoom[( (menu.Features.zoom.mode.value == 'Mode: Single' and 'first') or lp.zoom == 1 and 'first' or 'second')].value
        val = utils.lerp(val, distance - distance * slider/100, 0.03)
        cvar.cam_idealdist:set_raw_float(val)
    end
    menu.Features.zoom.on:set_event('paint', animation)
    menu.Features.zoom.on:set_callback(function(self)
        -- refs2.zoom:set_enabled(not self.value)
        -- refs2.fov:set_enabled(not self.value)
        if not self.value then 
            cvar.cam_idealdist:set_raw_float(default.dist)
        end
    end)
    defer(function()
        cvar.cam_idealdist:set_raw_float(default.dist)

    end)
end

local aspectratio do
    local self = menu.Features.aspect
    local setup = function(val)
        cvar.r_aspectratio:set_raw_float((not self.on.value or self.ratio.value == 59 or not val) and 0 or self.ratio.value/100)
    end

    self.on:set_callback(setup, true)
    self.ratio:set_callback(setup)
    defer(setup)
end

local viewmodel do
    viewmodel = default.viewmodel
    local self = menu.Features.viewmodel
    local setup = function(val, name)
        if not val or not name then
            for a, b in pairs(viewmodel) do
                local el =  cvar['viewmodel_' .. (#a > 1 and a or 'offset_'..a)]
                el:set_raw_float(val and self.on.value and self[a].value / (#a == 1 and 10 or 1) or b)
            end
        elseif self.on.value then
            local a = cvar['viewmodel_' .. (#name > 1 and name or 'offset_'..name)]
            a:set_raw_float(self[name].value / (#name == 1 and 10 or 1))
        end
    end

    self.on:set_callback(setup, true)
    for name, val in pairs(viewmodel) do
        self[name]:set_callback(function(this)
            setup(this, name)
        end)
    end

    do
        local weapon_raw = ffi.cast('void****', ffi.cast('char*', client.find_signature('client_panorama.dll', '\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0')) + 2)[0]
        local ccsweaponinfo_t = [[struct{
            char __pad_0x0000[0x1cd];
            bool hide_vm_scope;
        }]]
        local get_weapon_info = vtable_thunk(2, ccsweaponinfo_t .. '*(__thiscall*)(void*, unsigned int)')
        client.set_event_callback('run_command', function()
            if not lp.entity then return end
            local weapon = entity.get_player_weapon(lp.entity)
            if not weapon then return end
            get_weapon_info(weapon_raw, entity.get_prop(weapon, 'm_iItemDefinitionIndex')).hide_vm_scope = not (self.scope.value and self.on.value)
        end)

        defer(function()
            setup()
            if not lp.entity then return end
            local weapon = entity.get_player_weapon(lp.entity)
            if not weapon then return end
            get_weapon_info(weapon_raw, entity.get_prop(weapon, 'm_iItemDefinitionIndex')).hide_vm_scope = true
        end)
    end
    
end

local ragelogs do
    local data, hitlog = {}, {}
    local hitgroups = {'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear', 'nil'}

    menu.Features.logs.on:set_event('aim_fire', function(e)  
        data.hitgroup = e.hitgroup
        data.damage = e.damage
        -- data.bt = e.backtrack
        data.bt = globals.tickcount() - e.tick
        data.lc = e.teleported
    end)

    local self = menu.Features.logs
    self.on:set_event('aim_miss', function(e)  
        local col = color(unpack(menu.Features.color[e.reason].color.value)) or color(255,255,255,255)
        if self.display:get("On Screen") then
            table.insert(hitlog, {"\f<col2> Miss \f<col>"..entity.get_player_name(e.target).."\f<col2>'s \f<col>"..hitgroups[e.hitgroup].."\f<col2> due to \f<col>"..e.reason, 
            globals.curtime() +  menu.Features.logs.time.value*.1, 0.1, nil, col})
        end
        if self.display:get("In Console") then
            col = (utils.to_hex(col)):sub(1,6)
            pui.macros.col = '\a'..col
            utils.printc(pui.format(
                "\f<r>[\f<col>rinnegan\f<r>] ~ Miss "..
                "\f<col>"..entity.get_player_name(e.target).."\f<r>'s "..
                "\f<col>"..(hitgroups[e.hitgroup] or "?")..
                "\f<r> due to \f<col>"..e.reason.."\f<r>"..
                (e.reason == 'spread' and "(\f<col>"..string.format('%.0f', e.hit_chance).."\f<r>%)" or '')..
                (data.bt ~= 0 and ' (\f<col>'..data.bt..'\f<r> bt)' or '')..
                (data.lc and ' (\f<col>LC\f<r>)' or '')
            ))
        end
    end)
    self.on:set_event('aim_hit', function(e)
        local col = utils.to_hex(color(unpack(menu.Features.color['hit'].color.value)) or color(255,255,255,255))
        if self.display:get("On Screen") then
            table.insert(hitlog, {
                "\f<col2> Hit \f<col>"..entity.get_player_name(e.target).."\f<col2>'s \f<col>"..(hitgroups[e.hitgroup] or '?').."\f<col2> for \f<col>"..e.damage.." \f<col2>dmg", 
                globals.curtime() +  menu.Features.logs.time.value*.1, 0.1, nil, color(unpack(menu.Features.color['hit'].color.value)) })
        end
        if self.display:get("In Console") then
            col = col:sub(1,6)
            pui.macros.col = '\a'..col
            local health = entity.get_prop(e.target, 'm_iHealth')
            utils.printc(pui.format(
                "\f<r>[\f<col>rinnegan\f<r>] ~ Hit "..
                "\f<col>"..entity.get_player_name(e.target).."\f<r>'s "..
                "\f<col>"..(hitgroups[e.hitgroup] or "?")..
                (e.hitgroup ~= data.hitgroup and "\f<r>(\f<col>"..hitgroups[data.hitgroup].."\f<r>)" or '')..
                "\f<r> for \f<col>"..e.damage.."\f<r>"..
                (e.damage ~= data.damage and "\f<r>(\f<col>"..data.damage.."\f<r>) dmg" or ' dmg')..
                (e.reason == 'spread' and "(\f<col>"..string.format('%.0f', e.hit_chance).."\f<r>%)" or '')..
                " \f<col>~"..
                (health <= 0 and ' \f<r>(\f<col>dead\f<r>)' or ' \f<r>(\f<col>'..health..'\f<r> hp)')..
                (data.bt ~= 0 and ' (\f<col>'..data.bt..'\f<r> bt)' or '')..
                (data.lc and ' (\f<col>LC\f<r>)' or '')
            ))
        end
    end)

    local render = function()
        if not self.display:get('On Screen') then return end
        if #hitlog > 0 then
            if hitlog[1][3] <= 0.07 or #hitlog > 7 then
                table.remove(hitlog, 1)
            end
            for i = 1, #hitlog do
                local curtime = globals.curtime()
                hitlog[i][3] = utils.lerp(hitlog[i][3], curtime >= hitlog[i][2] and 0 or 1, 0.03)
                hitlog[i][4] = not hitlog[i][4] and i * 50 or utils.lerp(hitlog[i][4], curtime >= hitlog[i][2] and i * -10 or (hitlog[i - 1] and curtime >= hitlog[i - 1][2] and i-1 or i) * 30, 0.035)

                local text_color = hitlog[i][5]:clone()
                pui.macros.col = '\a'..utils.to_hex(text_color:alpha_modulate(text_color.a * hitlog[i][3]))

                local text_color2 = color(255,255,255,100)
                pui.macros.col2 = '\a'..utils.to_hex(text_color2:alpha_modulate(text_color2.a * hitlog[i][3]))

                local text = pui.format(hitlog[i][1])
                local measure = vector(renderer.measure_text('d', text))
                local y = screen.size.y * 0.73 - (1 - hitlog[i][4])

                local c = colors['logs']['Background']
                utils.rectangle(
                        screen.center.x - math.floor(measure.x * 0.55), y - 3,
                        math.floor(measure.x * 0.55) * 2, measure.y + 7,
                        c.r,c.g,c.b,c.a * hitlog[i][3],
                        5
                )
                renderer.text(screen.center.x - measure.x * 0.5, y, 0,0,0,0, 'd', 0, text)
            end
        end
    end
    self.on:set_event('paint', render)
    client.set_event_callback('round_poststart', function()
        hitlog = {}
    end)
    self.on:set_callback(function(self)
        refs2.log_dealt:override(not self.value and nil or false)
        refs2.log_dealt:set_enabled(not self.value)
        refs2.log_spread:override(not self.value and nil or false)
        refs2.log_spread:set_enabled(not self.value)
    end, true)
end

-- local animations do
--     local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
--     local char_ptr = ffi.typeof('char*')
--     local nullptr = ffi.new('void*')
--     local class_ptr = ffi.typeof('void***')
--     local animation_layer_t = ffi.typeof([[
--         struct {										char pad0[0x18];
--             uint32_t	sequence;
--             float		prev_cycle;
--             float		weight;
--             float		weight_delta_rate;
--             float		playback_rate;
--             float		cycle;
--             void		*entity;						char pad1[0x4];
--         } **
--     ]])
    
--     local setup = function(e)
--         if not lp.entity or not entity.is_alive(lp.entity) then return end
    
--         local player_ptr = ffi.cast(class_ptr, native_GetClientEntity(lp.entity))
--         if player_ptr == nullptr then return end
    
--         local anim_layers = ffi.cast(animation_layer_t, ffi.cast(char_ptr, player_ptr) + 0x2990)[0]
    
--         if lp.on_ground then
--             refs.other.legmovement:override(
--                 menu.Features.animations.ground.value == "Default" and "Off" or 
--                 ((menu.Features.animations.ground.value == "Never slide" or menu.Features.animations.ground.value == "Always slide") and menu.Features.animations.ground.value) or 
--                 (menu.Features.animations.ground.value == "Jitter" and (globals.tickcount() % 11 <= 2 and "Always slide" or "Never slide")) or
--                 "Never slide"
--             )
--             if menu.Features.animations.ground.value == "Moonwalk" then 
--                 entity.set_prop(lp.entity, "m_flPoseParameter", 0.5, 7) 
--             end
    
--             if menu.Features.animations.extra:get("Landing Pitch") then
--                 local my_data = entity2(lp.entity)
--                 if my_data then
--                     local animstate = entity2.get_anim_state(my_data)
--                     if animstate then
--                         if animstate.hit_in_ground_animation then
--                             entity.set_prop(lp.entity, 'm_flPoseParameter', 0.5, 12)
--                         end
--                     end
--                 end
--             end 

--             if menu.Features.animations.extra:get("Disable Move Lean") then
--                 anim_layers[6]['weight'] = 0
--             end
--         else 
--             if menu.Features.animations.air.value == "Static" then 
--                 entity.set_prop(lp.entity, "m_flPoseParameter", 1, 6)
--             elseif menu.Features.animations.air.value == "Moonwalk" then
--                 anim_layers[6]['weight'] = 1
--             end
--         end
--     end
--     menu.Features.animations.on:set_event('pre_render', setup)
--     menu.Features.animations.on:set_callback(function(self)
--         if not self.value then
--             refs.other.legmovement:override("Off")
--         end
--     end)
-- end

local filter do
    menu.Features.console.on:set_callback(function(self)
        client.delay_call(0, function()
            cvar.con_filter_enable:set_int(self.value and 1 or 0)
            cvar.con_filter_text:set_string(self.value and 'Rinnegan ['..version[1] ..']' or '')
        end)
    end, true)
    defer(function()
        cvar.con_filter_enable:set_int(0)
        cvar.con_filter_text:set_string('')
    end)
end

local manuals do
    manuals = {
        {
            [menu.Antiaims.hotkeys.forward] = {
                state = false,
                yaw = "Forward",
            },
            [menu.Antiaims.hotkeys.left]  = {
                state = false,
                yaw = "Left",
            },
            [menu.Antiaims.hotkeys.right] = {
                state = false,
                yaw = "Right",
            },
        },
        {
            ["Forward"] = 180,
            ["Left"] = -90,
            ["Right"] = 90,
        },
        {
            ["Forward"] = {1,-70,"^"},
            ["Left"] = {-70,1,"<"},
            ["Right"] = {70,1,">"},
        },
    }
    local handle_manuals = function()
        for key, value in pairs(manuals[1]) do
            local state, m_mode = key:get()
            if state ~= value.state then
                value.state = state
                if m_mode == 1 then
                    lp.manual = state and value.yaw or nil
                end
    
                if m_mode == 2 then
                    if lp.manual == value.yaw then
                        lp.manual = nil
                    else
                        lp.manual = value.yaw
                    end
                end
            end
    
        end
    end
    client.set_event_callback('paint', handle_manuals)

    local alpha,x,y = 0,0,0
    local last = nil
    local this = nil
    local render = function()
        if not lp.entity or not entity.is_alive(lp.entity) then return end
        this = lp.manual
        last = this and this or last
        if not last then return end
        y = utils.lerp(y,this and manuals[3][last][2] or 0, 0.03)
        x = utils.lerp(x,this and manuals[3][last][1] or 0, 0.03)
        alpha = utils.lerp(alpha, this and math.sqrt( x^2 +y^2 )/math.sqrt( manuals[3][last][1]^2 +manuals[3][last][2]^2 ) * (alpha < 0.75 and 0.9 or 1) or 0, 0.03)
        if alpha <= 0.1 then return end
        local c = colors["manual"]['Color']
        renderer.text(screen.center.x+x-1, screen.center.y+y-1, c.r,c.g,c.b,c.a * alpha,'+cd',0,manuals[3][last][3]:upper())
    end
    menu.Features.manual.on:set_event('paint', render)
end

local exploit do
    exploit = { }
    exploit.def_aa = false
    local BREAK_LAG_COMPENSATION_DISTANCE_SQR = 64 * 64

    local max_tickbase = 0
    local run_command_number = 0

    local data = {
        old_origin = vector(),
        old_simtime = 0.0,

        shift = false,
        breaking_lc = false,

        defensive = {
            force = false,
            left = 0,
            max = 0,
        },

        lagcompensation = {
            distance = 0.0,
            teleport = false
        }
    }

    local function update_tickbase(me)
        data.shift = globals.tickcount() > entity.get_prop(me, 'm_nTickBase')
    end

    local function update_teleport(old_origin, new_origin)
        local delta = new_origin - old_origin
        local distance = delta:lengthsqr()

        local is_teleport = distance > BREAK_LAG_COMPENSATION_DISTANCE_SQR

        data.breaking_lc = is_teleport

        data.lagcompensation.distance = distance
        data.lagcompensation.teleport = is_teleport
    end

    local function update_lagcompensation(me)
        local old_origin = data.old_origin
        local old_simtime = data.old_simtime

        local origin = vector(entity.get_origin(me))
        local simtime = toticks(entity.get_prop(me, 'm_flSimulationTime'))

        if old_simtime ~= nil then
            local delta = simtime - old_simtime

            if delta < 0 or delta > 0 and delta <= 64 then
                update_teleport(old_origin, origin)
            end
        end

        data.old_origin = origin
        data.old_simtime = simtime
    end

    local function update_defensive_tick(me)
        local tickbase = entity.get_prop(me, 'm_nTickBase')

        if math.abs(tickbase - max_tickbase) > 64 then
            -- nullify highest tickbase if the difference is too big
            max_tickbase = 0
        end

        local defensive_ticks_left = 0

        -- defensive effect can be achieved because the lag compensation is made so that
        -- it doesn't write records if the current simulation time is less than/equals highest acknowledged simulation time
        -- https://gitlab.com/KittenPopo/csgo-2018-source/-/blame/main/game/server/player_lagcompensation.cpp#L723

        if tickbase > max_tickbase then
            max_tickbase = tickbase
        elseif max_tickbase > tickbase then
            defensive_ticks_left = math.min(14, math.max(0, max_tickbase - tickbase - 1))
        end

        if defensive_ticks_left > 0 then
            data.breaking_lc = true
            data.defensive.left = defensive_ticks_left

            if data.defensive.max == 0 then
                data.defensive.max = defensive_ticks_left
            end
        else
            data.defensive.left = 0
            data.defensive.max = 0
        end
    end

    function exploit.get()
        return data
    end

    local function on_predict_command(cmd)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        if cmd.command_number == run_command_number then
            update_defensive_tick(me)
            run_command_number = nil
        end
    end

    local function on_setup_command(cmd)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        update_tickbase(me)
    end

    local function on_run_command(e)
        run_command_number = e.command_number
    end

    local function on_net_update_start()
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        update_lagcompensation(me)
    end

    client.set_event_callback('predict_command', on_predict_command)
    client.set_event_callback('setup_command', on_setup_command)
    client.set_event_callback('run_command', on_run_command)

    client.set_event_callback('net_update_start', on_net_update_start)
end

local antiaims do
    local antiaims = {
        pitch = {
            ['Random'] = function()
                return client.random_int(-89,89)
            end,
            ['Custom'] = function(e)
                return e.pitch_val:get()
            end,
            ['Progressive'] = function(e)
                return (utils.sine_yaw(globals.servertickcount() * e.pitch_speed.value * 0.1, e.pitch_min.value, e.pitch_max.value))
            end
        },
        yaw = {
            ['Sideways'] = function()
                return globals.tickcount() % 6 <= 2 and 90 or -90
            end,
            ['Sideways 45'] = function()
                return globals.tickcount() % 6 <= 2 and 45 or -45
            end,
            ['Spin'] = function(e)
                return utils.normalize_yaw(globals.servertickcount() * e.yaw_speed.value)
            end,
            ['Progressive'] = function(e)
                return (utils.sine_yaw(globals.servertickcount() * e.yaw_speed.value * 0.1, e.yaw_min.value, e.yaw_max.value))
            end,
            ['Random'] = function()
                return client.random_int(-180,180)
            end,
            ['Custom'] = function(e)
                return not e.yaw_invert and e.yaw_val:get() or e.yaw_val:get() + (e.yaw_invert:get() and 180 or 0)
            end,
            ['Yaw Opposite'] = function(yaw)
                return utils.normalize_yaw(yaw+180)
            end,
            ['Yaw Side'] = function(val)
                return val
            end
        }
    }
    local body_yaw,packets,offset,fl = 0,0,0,0
    local delay = {left=0,right=0,switch_ticks=0,work_side='left',switch=false}

    local setup = function(cmd)
        refs.fl.enabled:override( not (
            (menu.Antiaims.other.fl_disabler.value[1] == "Standing") and (lp.on_ground and not lp.moving) or
            (menu.Antiaims.other.fl_disabler.value[1] == "Crouch Move" or menu.Antiaims.other.fl_disabler.value[2] == "Crouch Move") and (lp.on_ground and lp.crouch and lp.moving)
        ) )

        -- if menu.Antiaims.other.unsafe.value then
        --     exploits:allow_unsafe_charge(true)
        -- end

        refs.aa.enabled:override(true)
        refs.aa.pitch:override('Minimal')
        refs.aa.yaw:override("180")
        refs.aa.roll:override(0)

        local aa = (lp.manual or menu.Antiaims.builder[lp.state].enabled.value) and menu.Antiaims.builder[lp.state] or menu.Antiaims.builder[condition_list[1]]

        refs.aa.yaw_base:override(aa.yaw.base.value)
        refs.aa.body:override(aa.body.yaw.value == "Jitter" and "Static" or aa.body.yaw.value)

        if globals.chokedcommands() == 0 then
            if aa.body.delay.mode.value == "Static" then
                packets = packets > aa.body.delay.delay.value * 2 - 2 and 0 or packets + 1
            else
                delay.switch_ticks = (aa.body.delay.switch.value == 0 and -1) or (delay.switch_ticks > aa.body.delay.switch.value - 2 and 0 or delay.switch_ticks + 1)
                if delay.switch_ticks == 0 then
                    delay.switch = not delay.switch
                else
                    delay.switch = (aa.body.delay.switch.value == 0 and false) or delay.switch
                end
                delay.work_side = (delay[delay.work_side] > ( aa.body.delay[(delay.switch and (delay.work_side == 'left' and 'right' or 'left') or delay.work_side)].value - 2 ) and (delay.work_side == 'left' and 'right' or 'left')) or delay.work_side
                delay[delay.work_side] = (delay[delay.work_side] > ( aa.body.delay[ (delay.switch and (delay.work_side == 'left' and 'right' or 'left') or delay.work_side) ].value - 2 )) and 0 or delay[delay.work_side] + 1
            end
        end
        local inverted = (function()
            if aa.body.yaw.value == 'Static' then 
                return aa.body.side.value == 1
            elseif aa.body.yaw.value == 'Jitter' then
                if aa.body.delay.mode.value == "Switch" then
                    return delay.work_side == 'right'
                else
                    return packets % (aa.body.delay.delay.value * 2) >= aa.body.delay.delay.value
                end
            end
        end)()

        local yaw_jitter = aa.jitter.type.value
        if yaw_jitter == "3-Way" or yaw_jitter == '5-Way' then
            offset = aa.jitter.ways[(globals.tickcount() % (yaw_jitter == '3-Way' and 3 or 5)) + 1].value
            yaw_jitter = 'Off'
            offset = client.random_int(offset-aa.jitter.rand.value, offset+aa.jitter.rand.value)
        else
            offset = 0
        end

        refs.aa.jitter:override(yaw_jitter ~= "Spin" and yaw_jitter or "Off")
        local jitter_val = 0
        if yaw_jitter ~= 'Off' then
            jitter_val = (
                aa.jitter.mode.value == "Spin" and utils.sine_yaw(globals.servertickcount(), aa.jitter.value2.value, aa.jitter.value.value) 
                or (aa.jitter.mode.value == "Random" and client.random_int(0,1) == 1 or 
                aa.jitter.mode.value == 'Switch' and globals.tickcount() % 6 <= 2) and aa.jitter.value2.value or aa.jitter.value.value
            )
            jitter_val = client.random_int(jitter_val-aa.jitter.rand.value, jitter_val+aa.jitter.rand.value)
        end
        refs.aa.jitter_val:override(utils.normalize_yaw(jitter_val))
        
        
        refs.aa.body_val:override(inverted and 1 or -1)
        local yaw = utils.normalize_yaw(
            lp.manual and manuals[2][lp.manual] + offset 
            or aa.yaw.global.value + (inverted and aa.yaw.right.value or aa.yaw.left.value) + offset
        )

        refs.aa.yaw_val:override(yaw)
        refs.aa.edge:override(menu.Antiaims.hotkeys.edge:get() and not lp.manual)
        refs.aa.fs:set_hotkey("Always On", 0)
        if menu.Antiaims.hotkeys.fs:get() and not lp.manual then
            refs.aa.fs:override(true)
            if menu.Antiaims.hotkeys.fs_disablers:get("Body Yaw") then refs.aa.body:override("Off") end
            if menu.Antiaims.hotkeys.fs_disablers:get("Yaw Jitter") then refs.aa.jitter:override("Off") end
        else
            refs.aa.fs:override(false)
        end
        if lp.state ~= condition_list[9] then
            if aa.defensive.force.value and not menu.Antiaims.other2.defensive:get("Force Def.") then
                cmd.force_defensive = true
            end
            if lp.flicking then
                cmd.force_defensive = cmd.command_number % 7 == 0
            end
            if (aa.defensive.enabled.value and not menu.Antiaims.other2.defensive:get("Def. AA") or lp.flicking) and not refs2.fd:get() then
                local this = lp.flicking and menu.Antiaims.other2.flick_aa or (aa.defensive.override and aa.defensive.override.value and aa or menu.Antiaims.builder[condition_list[1]]).defensive.settings
                local exp = exploit.get().defensive.left
                local work = exp ~= 0 and (lp.flicking or exp <= this.duration.value)
                exploit.def_aa = false
                if work then
                    exploit.def_aa = true
                    if this.disablers:get("Body Yaw") then refs.aa.body:override('Off') end
                    if this.disablers:get("Yaw Jitter") then refs.aa.jitter:override('Off') end
                    if this.pitch.value ~= "None" then
                        refs.aa.pitch:override('Custom')
                        refs.aa.pitch_val:override(antiaims.pitch[this.pitch.value](this))
                    end
                    local ezz = {
                        ['Yaw Opposite'] = yaw,
                        ['Yaw Side'] = lp.state == condition_list[10] and yaw + 180 or aa.yaw.global.value + (inverted and aa.yaw.left.value or aa.yaw.right.value)
                    }
                    if this.yaw.value ~= "None" then
                        refs.aa.yaw:override('180')
                        refs.aa.yaw_val:override(utils.normalize_yaw(antiaims.yaw[this.yaw.value](ezz[this.yaw.value] or this)))
                    end
                end
            end
        end

        if menu.Antiaims.other.avoid_backstab.value then
            local origin = vector(entity.get_origin(lp.entity))
            for _,v in ipairs(entity.get_players(true)) do 
                if entity.get_classname(entity.get_player_weapon(v)) == "CKnife" then
                    if origin:dist(vector(entity.get_origin(v))) <= 200 then
                        refs.aa.pitch:override("Off")
                        refs.aa.yaw:override('180')
                        refs.aa.yaw_val:override(180)
                        refs.aa.body:override('Opposite')
                    end
                end
            end
        end

    end
    client.set_event_callback("setup_command", setup)
    defer(function()
        refs.fl.enabled:override(nil)
        for _,ref in pairs(refs.aa) do
            ref:override(nil)
        end
    end)
end

local helper do
    helper = {
        ['Crosshair'] = function()
            return screen.center.x, screen.center.y
        end,
        ['Upper-Center'] = function()
            return screen.center.x, 0
        end,
        ['Bottom-Center'] = function()
            return screen.center.x, screen.size.y
        end,
        ['Local Player'] = function(id)
            local stomach_x, stomach_y, stomach_z = entity.hitbox_position(id, 3)
            return renderer.world_to_screen(stomach_x, stomach_y, stomach_z)
        end,
    }
    local render = function()
        if not lp.entity or not entity.is_alive(lp.entity) then return end
        local weapon_ent = entity.get_player_weapon(lp.entity)
        local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
        if weapon_idx == nil then return end
    
        for i, id in pairs(entity.get_players(true)) do
            local weapon = csgo_weapons[weapon_idx]

            local distance = vector(entity.get_prop(lp.entity, "m_vecAbsOrigin")):dist(vector(entity.get_prop(id, "m_vecOrigin")))
            local dmg_after_range = (weapon.damage * math.pow(weapon.range_modifier, (distance * 0.002)))
            local armor = entity.get_prop(id,"m_ArmorValue")
            local newdmg = dmg_after_range * (weapon.armor_ratio * 0.5)
            if dmg_after_range - (dmg_after_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
                newdmg = dmg_after_range - (armor / 0.5)
            end
            local picked = (menu.Features.helper[(refs2.thirdperson.value and refs2.thirdperson:get_hotkey() and 'third' or 'first')].value):sub(14, 30)
            local stomach_x, stomach_y, stomach_z = entity.hitbox_position(id, 3)
            local wx, wy = renderer.world_to_screen(stomach_x, stomach_y, stomach_z)
            local wx2, wy2 = helper[picked](lp.entity)
            if wx and wy then
                if --[[(id == client.current_threat()) and]] not (entity.get_prop(id, "m_iHealth") >= newdmg * 1.25) then
                    local c = colors['helper']['Color']
                    renderer.line(wx2, wy2, wx,wy, c.r,c.g,c.b,c.a)
                end
            end
        end
    end
    menu.Features.helper.on:set_event("paint", render)
end

local tracer do
    tracer = {}
    local inserting = function(e)
        if client.userid_to_entindex(e.userid) == entity.get_local_player() then
            table.insert(tracer, {{client.eye_position()}, {e.x, e.y, e.z}, globals.curtime() + menu.Features.tracer.time.value * .1, 0.1})
        end
    end
    menu.Features.tracer.on:set_event('bullet_impact', inserting)

    local render = function()
        for id, data in pairs(tracer) do
            data[4] = utils.lerp(data[4], globals.curtime() >= data[3] and 0 or 1, 0.035)
            if data[4] < 0.08 then
                tracer[id] = nil
            end
            local x1, y1 = renderer.world_to_screen(data[1][1], data[1][2], data[1][3])
            local x2, y2 = renderer.world_to_screen(data[2][1], data[2][2], data[2][3])
            if x1 and x2 and y1 and y2 then
                local c = colors['tracer']["Color"]
                renderer.line(x1, y1, x2, y2, c.r,c.g,c.b,c.a*data[4])
            end
        end
    end
    menu.Features.tracer.on:set_event('paint', render)
end

local trashtalk do
    trashtalk = {
        kill = {1, {
            {"god bless no stress ты опущен by 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 хуесос"},
            {"owned by DODO corporation"},
            {"сочник ебанный", 'сиди в дэде'},
            {"в следующий раз заходи с 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 чтобы не позорится"},
            {"ты наверное с экскордом играешь","я твои аахи вообще не ощущаю"},
            {"1 уебище глупое ты заебал с ванвея падать"},
            {"ахахах нищара нищая нормас анти аимы у тебя, асид теч?"},
            {"1 собака ебучая, после этого точно выключай компьютер, завтра в школу"},
            {"ахахаха овца я ща синий винстон вкуриваю и ебу тебя на легке"},
            {"улетаеш в копилку мертвых сочников"},
            {"ёк макарек египетская сила как я зарядил тебе"},
            {"депортирован в ад к матери шлюхе"},
            {"мне показалось","или у тебя крутилка была оффнута?"},
            {"куда ты пикаешь то","засранец ебаный"},
            {"впитывай и терпи, с такой луа как у тебя не привыкать"},
            {"оооуууу ахуеть","вот это я тебя тапнул"},
            {"пацаны скиньте 5000р","отсосу"},
            {"пацаны че за хуйня?","ноги лагают"},
            {"0iq"},
            {"нихуя себе ты играешь","в тюрьме бы тебя называли туалетный водолаз"},
            {"нихуя се ты сочный....","прям как кириешки..","со стейком"},
            {"нищенка","в честь тебя даже реку назвали"},
            {"не отвечаю?","знай своё место"},
            {"ливнёшь мамка шлюха","не ливнёшь отец пидорас"},
            {"сосал?","соври", 'не ври'},
            {"пацаны на мобилизации мобилы не раздают","это наебалово"},
            {"норм играешь", 'сын шлюхи'},
            {'1', 'мб walkbot вырубишь?'},
            {"ебать ты хуёвый"},
            {"блоха ебанная", 'куда ты выбежала?'},
            {"пацаны чё за хуйня?", 'у мя моделька крутится'},
            {'ебанный хуесос', 'который раз ты лежишь в ногах юзера 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏?'},
            {'в очередной раз этот сочник у меня в ногах'},
            {'норм мисаешь, сын бляди'},
            {'переигран хуесос'},
            {'ебанный бич','почему ты сдох? оправдайся'},
            {"луасенс не бустит - 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 поможет сын шалавы"},
            {"ты че мразота ? вздумал тягатся с 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 юзером?"},
            {"1 бот ты чо не вывез 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 system aa"},
            {"сын шлюхенции ты чет слабый для 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏"},
            {"я призываю свою Ōtsutsuki банду 5x5}, все 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 users были"},
            {"членом придавил тебя buy 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏"},
            {"ЫВЗ9ГРШО4УГР9ЗУЦКЕНРТГЗ9 тупейший без 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 :3"},
            {"че ты опять хнычешь в чат, покупай 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 и будь т1"},
            {" убил бомжа без 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏"},
            {"Только умные люди играют с 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏"},
            {"почему я опять тя убил пидораса? У меня куплен 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏"},
            {"Чё опять не попал да? купи 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 терпила"},
            {"братан, у меня 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏 с гм аа, соси хуй"},
            {"kys rinnegan-less fag"},
            {"am i him? yeah, i use rinnegan"},
            {"stop slaving and buy rinnegan"},
            {"ṛïṅṅëġäṅ ḋöṁïṅäẗëṡ ḧṿḧ ṡċëṅë"},
            {"you need rinnegan stupid kids"},
            {"lord of missing is one, and its rinnegan"},
            {"stop missing already, just be like me and get rinnegan"},
            {"ru pastes destroyed from rinnegan release"},
            {"𝗶 𝘂𝘀𝗲 𝗿𝗶𝗻𝗻𝗲𝗴𝗮𝗻 𝘄𝘁𝗳"},
            {"𝒓𝒊𝒏𝒏𝒆𝒈𝒂𝒏 [𝒈𝒐𝒅𝒎𝒐𝒅𝒆] 𝒆𝒏𝒂𝒃𝒍𝒆𝒅"},
            {"【𝐃】【𝐞】【𝐥】【𝐞】【𝐭】【𝐞】【𝐝】 𝐛𝐲 𝐑𝐢𝐧𝐧𝐞𝐠𝐚𝐧 - 𝐠𝐞𝐭 𝐠𝐨𝐨𝐝"},
            {"𝑻𝒉𝒊𝒔 𝒂𝒊𝒏’𝒕 𝒆𝒗𝒆𝒏 𝒇𝒂𝒊𝒓 - 𝑰 𝒖𝒔𝒆 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏"},
            {"Sage of Six Paths granted me 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏, so i could destroy you"},
            {"There's no dimensions that u win in. I already checked with 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏"},
            {"You can't see my Limbo without 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏"},
            {"You are not blessed by Ōtsutsuki gods, you don't have 𝑹𝒊𝒏𝒏𝒆𝒈𝒂𝒏"},
            {"𝙧𝙚𝙩𝙞𝙧𝙚 𝙗𝙚𝙛𝙤𝙧𝙚 𝙍𝙞𝙣𝙣𝙚𝙜𝙖𝙣 𝙛𝙞𝙣𝙙𝙨 𝙮𝙤𝙪"},
            {"𝟙𝕟𝕖𝕕 𝕒𝕘𝕒𝕚𝕟 𝕓𝕪 𝕣𝕚𝕟𝕟𝕖𝕘𝕒𝕟"},
            {"𝔟𝔢𝔱𝔱𝔢𝔯 𝔭𝔞𝔰𝔰 𝔱𝔥𝔢 𝔠𝔬𝔫𝔱𝔯𝔬𝔩𝔩𝔢𝔯"},
            {"𝟷𝟶𝟶% 𝚘𝚠𝚗𝚎𝚍 𝚋𝚢 𝚁𝚒𝚗𝚗𝚎𝚐𝚊𝚗"},
            {"ʏᴏᴜʀ ʜᴏᴘᴇs ᴡᴇʀᴇ ᴄʀᴜsʜᴇᴅ ʙʏ ʀɪɴɴᴇɢᴀɴ"},
            {"『Y』『O』『U』『R』 『W』『I』『L』『L』 『I』『S』 『M』『I』『N』『E』"},
            {"𝚛𝚎𝚜𝚙𝚊𝚠𝚗 𝚏𝚊𝚜𝚝, 𝚁𝚒𝚗𝚗𝚎𝚐𝚊𝚗 𝚒𝚜 𝚠𝚊𝚒𝚝𝚒𝚗𝚐"},
            {"𝔊𝔬𝔡 𝔒𝔣 𝔗𝔥𝔦𝔰 𝔊𝔞𝔪𝔢 | 𝔞𝔠𝔱𝔦𝔳𝔞𝔱𝔢𝔡"},
            {"𝓁𝒾𝓃𝓀 𝓉𝓇𝓎 𝒶𝑔𝒶𝒾𝓃, 𝓎𝑜𝓊'𝓁𝓁 𝓈𝓉𝒾𝓁𝓁 𝓁𝑜𝓈𝑒"},
            {"𝓵𝓾𝓬𝓴 𝓭𝓸𝓮𝓼𝓷'𝓽 𝓶𝓪𝓽𝓽𝓮𝓻 𝓪𝓰𝓪𝓲𝓷𝓼𝓽 𝓡𝓲𝓷𝓷𝓮𝓰𝓪𝓷"},
            {"𝓬𝓪𝓶𝓹 𝓱𝓪𝓻𝓭𝓮𝓻, 𝓲𝓽 𝔀𝓸𝓷’𝓽 𝓼𝓪𝓿𝓮 𝔂𝓸𝓾 (𝒷𝑜𝓁𝒹 𝓈𝒸𝓇𝒾𝓅𝓉)"},
            {"𝙱𝚎𝚝𝚝𝚎𝚛 𝚙𝚒𝚗𝚐 𝚌𝚊𝚗’𝚝 𝚜𝚊𝚟𝚎 𝚢𝚘𝚞"},
            {"𝕎𝕒𝕤 𝕥𝕙𝕒𝕥 𝕤𝕦𝕡𝕡𝕠𝕤𝕖𝕕 𝕥𝕠 𝕙𝕦𝕣𝕥?"},
            {"𝔂𝔬𝔲𝔯 𝔢𝔫𝔡 𝔴𝔞𝔰 𝔴𝔯𝔦𝔱𝔱𝔢𝔫 𝔟𝔶 𝔯𝔦𝔫𝔫𝔢𝔤𝔞𝔫"},
            {"𝙳𝚒𝚍 𝚢𝚘𝚞 𝚎𝚟𝚎𝚗 𝚝𝚛𝚢?"},
            {"𝕋𝕣𝕪 𝕒𝕘𝕒𝕚𝕟, 𝕓𝕦𝕥 𝕚𝕥 𝕨𝕠𝕟𝕥 𝕞𝕒𝕥𝕥𝕖𝕣"},
            {"𝙳𝚊𝚢 𝚘𝚗𝚎 𝚙𝚕𝚊𝚢𝚎𝚛, 𝙳𝚊𝚢 𝚘𝚗𝚎 𝚕𝚘𝚜𝚜"},
            {"𝚆𝚎𝚊𝚔 𝚑𝚊𝚗𝚍𝚜, 𝚜𝚕𝚘𝚠 𝚖𝚘𝚟𝚎𝚜, 𝚋𝚘𝚛𝚛𝚘𝚠𝚎𝚍 𝚝𝚒𝚖𝚎"},
            {"𝓷𝓸 𝓻𝓮𝓼𝓹𝓮𝓬𝓽 𝓯𝓸𝓻 𝓽𝓱𝓲𝓼 𝓬𝓸𝓶𝓹𝓮𝓽𝓲𝓽𝓲𝓸𝓷"},
            {"𝙎𝙖𝙢𝙚 𝙢𝙞𝙨𝙩𝙖𝙠𝙚, 𝙨𝙖𝙢𝙚 𝙧𝙚𝙨𝙪𝙡𝙩"},
            {"𝙶𝚊𝚖𝚎 𝚘𝚟𝚎𝚛, 𝚃𝚊𝚕𝚎 𝚘𝚏 𝚁𝚒𝚗𝚗𝚎𝚐𝚊𝚗 𝚌𝚘𝚗𝚝𝚒𝚗𝚞𝚎𝚜"},
            {"𝕍𝕚𝕔𝕥𝕠𝕣𝕪 𝕚𝕤 𝕨𝕣𝕚𝕥𝕥𝕖𝕟 𝕚𝕟 𝕞𝕪 𝕟𝕒𝕞𝕖"},
            {"𝓜𝓪𝓽𝓬𝓱 𝓸𝓿𝓮𝓻, 𝔂𝓸𝓾 𝔀𝓸𝓷𝓽 𝓫𝓮 𝓶𝓲𝓼𝓼𝓮𝓭"},
            {"𝓁𝒾𝓃𝓀 𝓉𝓎𝓅𝑒 𝓆𝓊𝒾𝑒𝓉𝓁𝓎, 𝓡𝓲𝓷𝓷𝓮𝓰𝓪𝓷 𝓻𝓮𝓪𝓭𝓼 𝒶𝓁𝓁"},
            {"𝔾𝔼𝕋 ℝ𝕀ℕℕ𝔼𝔾𝔸ℕ 𝕐𝕆𝕌 𝔽𝔸𝔾"},
            {"𝘐 𝘏𝘈𝘋 𝘛𝘖 𝘚𝘌𝘓𝘓 𝘔𝘠 𝘏𝘖𝘜𝘚𝘌 𝘛𝘖 𝘒𝘐𝘓𝘓 𝘠𝘖𝘜 𝕗𝕥. 𝕣𝕚𝕟𝕟𝕖𝕘𝕒𝕟"},
            {"ｒｉｎｎｅｇａｎ ｓｕｂ ｅｘｐｉｒｅ ＝ ｓｕｉｃｉｄｅ"},
            {"𝚙𝚘𝚕𝚊𝚗𝚍 𝚙𝚊𝚜𝚝𝚎 𝚍𝚎𝚜𝚝𝚛𝚘𝚢𝚜 𝚏𝚛𝚘𝚖 𝚁𝙸𝙽𝙽𝙴𝙶𝙰𝙽 𝚁𝙴𝙻𝙴𝙰𝚂𝙴.. (◣_◢)"},
            {"𝐫𝐢𝐧𝐧𝐞𝐠𝐚𝐧 𝕄𝔼𝕀ℕ 𝔾𝔸ℕ𝔾 𝕍𝕊 𝕋ℍ𝔼 𝕎𝕆ℝ𝕃𝔻"},
            {"𝔸𝔽𝕋𝔼ℝ 𝕀 𝕄𝕀𝕊𝕊𝔼𝔻 𝕌 𝟙𝟘 𝕋𝕀𝕄𝔼𝕊 𝕀 𝕀ℕ𝕁𝔼ℂ𝕋𝔼𝔻 ℝ𝕀ℕℕ𝔼𝔾𝔸ℕ ℝ𝔼ℂ𝕆𝔻𝔼"},
            {"ｏｕｔｌａｗ？ ｎｏ ＲＩＮＮＥＧＡＮ"},
            {"𝘆𝗼𝘂 𝗵𝗮𝘃𝗲 𝘁𝗼 𝗱𝗼 𝗮 𝗣𝗔𝗦𝗧𝗘 𝗰𝗵𝗲𝗰𝗸"},
            {"𝚛𝚒𝚗𝚗𝚎𝚐𝚊𝚗 𝚝𝚛𝚞𝚜𝚝 𝚏𝚊𝚌𝚝𝚘𝚛"},
        }},
        death = {1, {
            {"шлюха да что ты себе позволяешь","ну всё пидрила","!аdmin"},
            {"ты ахуел пидар","далбаёб"},
            {",kznm","как включять аим"},
            {"сервак тепнул"},
            {"ты какую луа на кастом резик юзаешь?"},
            {"CERF","я щас с огорода приду","зайду пизды те дам"},
            {"тебе повезло шлюха","ты меня убил только пушто у меня нос зачесался"},
            {"нихуя се у тя крутилка","подскажи настры"},
            {"как ты меня аншотнуло чмо","яж дт прожал"},
            {"ты как меня убил хуйпасос","Rayzen#5311 аддай шлюха"},
            {"ты как меня убил","!аdmin  ","ливай шлюха 5 сек даю"},
            {"блядь ебалн","сука тимейт куда то убежал"},
            {"ну нет мусор","блядь что ты делаешь бот ссаный"},
            {"о неееееет","сука хуйпачос ебаный ты заебал 1в пикать"},
            {"не ливай хуесос","щас поиграем долбаеб нищий"},
            {"убогий школьник","расскажи сколько ванвеев сегодня тапнул","хуйпоклык обрыганский"},
            {"блядт мусор господи","не ливай нахуй щас ты землю толкать пойдёшь","опарыш бля"},
            {"о боже пидрил","снова лишний вес нашей планеты убил"},
            {"ты меня убил хуесос,но за аллаха респект"},
            {"не ливай мусор я щас тебя выебу","можешь идти аллаху молиться на некст раунд"},
            {"инфузория ебаная ты что снова наделал","ты щас такой пизды получишь отвечаю","компьютер неделю включать не будешь"},
            {"глупый даун","после некст раунда ты захочешь с хвх ливнуть"},
            {"убил меня?","теперь радуйся сиди две минуты","хуесос нищий"},
            {"АХАХАХАХ","ТОЛЬКО НЕ ЭТО","тупорылый еблан"},
            {"миндмг","слетел"},
            {"отмена", 'там же прыгает', 'настоящий сын шлюхи'},
            {"чит же видит какой он бездарный", 'и даёт шанс этому хуесосу'},
            {"не ожидал что ты настолько тупорылый", 'запишу тебя в тетрадь сочников'},
            {'ебанный выблядок', 'как же тебе везёт'},
            {'чмырь ебанный', 'рн 5х5 на 5к евро'},
        }}
    }
    math.randomseed(client.unix_time())
    utils.shuffle_table(trashtalk.kill[2])
    utils.shuffle_table(trashtalk.death[2])
    local b = 0
    local trashsay = function(e)
        if not e then return end
        local table = e[2][e[1]]
        e[1] = e[1] + 1
        if e[1] == #e[2] then
            e[1] = 1
            utils.shuffle_table(e[2])
        end
        b = b + 1
        local a = b
        for i=1, #table do
            client.delay_call(i*2, function()
                if b == a then
                    client.exec('say "' .. table[i] .. '"')
                end
            end)
        end
    end
    menu.Features.trashtalk.on:set_event('player_death', function(e)
        local gamerules = entity.get_game_rules()
        if not gamerules then return end
        if entity.get_prop(gamerules, 'm_bWarmupPeriod') == 1 then return end
        local userid, attacker = client.userid_to_entindex(e.userid),client.userid_to_entindex(e.attacker)
        if userid == lp.entity then
            lp.zoom = 0
            lp.scoped = 0
        end
        if userid == attacker or (userid ~= lp.entity and attacker ~= lp.entity) then return end
        trashsay((attacker == lp.entity and (menu.Features.trashtalk.event:get("On Kill") and trashtalk.kill) or (menu.Features.trashtalk.event:get("On Death") and trashtalk.death)) or nil)
    end)
end

local fast_ladder do
    local setup = function(cmd)
        if entity.get_prop(lp.entity, 'm_MoveType') ~= 9 then return end
    
        local weapon = entity.get_player_weapon(lp.entity)
        if not weapon then return end
    
        local throw_time = entity.get_prop(weapon, 'm_fThrowTime')
    
        if throw_time ~= nil and throw_time ~= 0 then
            return
        end
        
        if cmd.forwardmove > 0 then
            if cmd.pitch < 45 then
                cmd.pitch = 89
                cmd.in_moveright = 1
                cmd.in_moveleft = 0
                cmd.in_forward = 0
                cmd.in_back = 1
        
                if cmd.sidemove == 0 then
                    cmd.yaw = cmd.yaw + 90
                end
        
                if cmd.sidemove < 0 then
                    cmd.yaw = cmd.yaw + 150
                end
        
                if cmd.sidemove > 0 then
                    cmd.yaw = cmd.yaw + 30
                end
            end
        elseif cmd.forwardmove < 0 then
            cmd.pitch = 89
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            cmd.in_forward = 1
            cmd.in_back = 0
        
            if cmd.sidemove == 0 then
                cmd.yaw = cmd.yaw + 90
            end
        
            if cmd.sidemove > 0 then
                cmd.yaw = cmd.yaw + 150
            end
        
            if cmd.sidemove < 0 then
                cmd.yaw = cmd.yaw + 30
            end
        end
    end
    
    menu.Antiaims.other.ladder:set_event('setup_command', setup)
end

local shot_marker do
    shot_marker = {}

    local function aim_fire(e)
        shot_marker[e.id] = {
            {e.x,e.y,e.z}, 
            globals.curtime() + menu.Features.marker.time.value *.1,
            0.1
        }
    end

    local function render()
        for id, data in pairs(shot_marker) do

            data[3] = utils.lerp(data[3], globals.curtime() >= data[2] and 0 or 1, 0.05)
            if data[3] < 0.08 then
                shot_marker[id] = nil
            end

            local x, y = renderer.world_to_screen(data[1][1], data[1][2], data[1][3])
            if x and y then
                local c = color(unpack(menu.Features.color[(data[4] or 'hit')].color.value)) or color(255,255,255,255)
                local x2 = menu.Features.marker.size.value / screen.size.x * screen.size.x
                local y2 = menu.Features.marker.size.value / screen.size.y * screen.size.y
                if menu.Features.marker.style.value == "Style: Plus" then
                    renderer.line(x + x2, y, x + 2 * x2, y, c.r,c.g,c.b,c.a * data[3])
                    renderer.line(x - x2, y, x - 2 * x2, y, c.r,c.g,c.b,c.a * data[3])
                    renderer.line(x, y - y2, x, y - 2 * y2, c.r,c.g,c.b,c.a * data[3])
                    renderer.line(x, y + y2, x, y + 2 * y2, c.r,c.g,c.b,c.a * data[3])
                else
                    renderer.line(x + x2, y + y2, x + 2 * x2, y + 2 * y2, c.r,c.g,c.b,c.a * data[3])
                    renderer.line(x - x2, y + y2, x - 2 * x2, y + 2 * y2, c.r,c.g,c.b,c.a * data[3])
                    renderer.line(x - x2, y - y2, x - 2 * x2, y - 2 * y2, c.r,c.g,c.b,c.a * data[3])
                    renderer.line(x + x2, y - y2, x + 2 * x2, y - 2 * y2, c.r,c.g,c.b,c.a * data[3])
                end
                if data[4] and menu.Features.marker.extra.value then
                    local size = renderer.measure_text('cd', data[4])
                    renderer.text(x + size/1.2, y, c.r,c.g,c.b,c.a * data[3], 'cd', 0, data[4])
                end
            end
        end
    end

    menu.Features.marker.on:set_event("aim_fire", aim_fire)
    menu.Features.marker.on:set_event("paint", render)
    menu.Features.marker.on:set_event('aim_miss', function(e)
        shot_marker[e.id][4] = e.reason
    end)

    menu.Features.marker.on:set_event("round_prestart", function()
        shot_marker = {}
    end)

end

local clantag do
    clantag = "Rinnegan"
    local gs_clantag = function(text, indices)
        local text_anim = '                ' .. text .. '                '
        -- local server_time = globals.curtime()
        -- local i = math.floor(server_time / 0.35) % #indices
        -- i = indices[i + 1] + 1
        -- i = math.floor(i % #indices)
        local tickinterval = globals.tickinterval()
        local tickcount = globals.tickcount()
        local tickcount = tickcount + math.floor(client.real_latency()+0.22 / tickinterval + 0.5)
        local i = tickcount / math.floor(0.3 / tickinterval + 0.5)
        i = math.floor(i % #indices)
        i = indices[i+1]+1
        return string.sub(text_anim, i, i+15)
    end
    
    local previous_tag = nil
    local setup = function()
        local game_rules = entity.get_game_rules()
        local m_gamePhase = entity.get_prop(game_rules, 'm_gamePhase')
        local NextPhase = entity.get_prop(game_rules, 'm_timeUntilNextPhaseStarts')
        local clan_tag do
            if m_gamePhase == 5 or NextPhase ~= 0 then
                clan_tag = clantag
            else
                clan_tag = gs_clantag(clantag, {0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 14, 14, 14, 14, 14, 14, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 24, 25})
            end
        end
        if clan_tag ~= previous_tag then
            client.set_clan_tag(clan_tag)
            previous_tag = clan_tag
        end
    end

    menu.Features.clantag.on:set_event('paint', setup)
    menu.Features.clantag.on:set_callback(function(self)
        refs2.tag:set_enabled(not self.value)

        if not self.value then
            refs2.tag:override()
            client.delay_call(0, function()
                client.set_clan_tag("")
            end)
        else
            refs2.tag:override(false)
        end
    end)

    defer(function()
        client.set_clan_tag("")
    end)
end

local stickman do
    stickman = {
        [0] = {1}, -- Head to Neck
        [1] = {6,15, 17}, -- Neck to Pelvis, Left Upper Arm, Right Upper Arm
        [2] = {3, 7, 8}, -- Pelvis to Stomach, Left Hip, Right Hip
        [3] = {4}, -- Stomach to Lower Chest
        [4] = {5}, -- Lower Chest to Chest
        [5] = {6}, -- Chest to Upper Chest
        [7] = {9}, -- Left Hip to Left Shin
        [8] = {10}, -- Right Hip to Right Shin
        [9] = {11}, -- Left Shin to Left Foot
        [10] = {12}, -- Right Shin to Right Foot
        [16] = {15}, -- Left Upper Arm to Left Forearm
        [17] = {14} -- Right Upper Arm to Right Forearm
    }
    local render = function()
        if not refs2.thirdperson:get_hotkey() then return end
        if not lp.entity or not entity.is_alive(lp.entity) then return end
        if menu.Features.stickman.def.value and exploit.def_aa or not menu.Features.stickman.def.value then
            for from, ids in pairs(stickman) do
                local x,y,z = entity.hitbox_position(lp.entity, from)
                if not x and not y and not y then return end
                local x1,y1 = renderer.world_to_screen(x,y,z)
                for _, id in pairs(ids) do
                    local x,y,z = entity.hitbox_position(lp.entity, id)
                    if not x and not y and not y then return end
                    local x2,y2 = renderer.world_to_screen(x,y,z)
                    local c = colors['stickman']['Color']
                    renderer.line(x1,y1,x2,y2, c.r,c.g,c.b,c.a)
                end
            end
        end
    end
    menu.Features.stickman.on:set_event('paint', render)
end

local velocity do 
    local a = 0
    local menu_a = 0
    local render = drag.register(menu.Features.velocity.drag, vector(300, 40), "velocity", function(self)
        if not lp.entity or not entity.is_alive(lp.entity) then return end
        menu_a = utils.lerp(menu_a, ui.is_menu_open() and 1 or 0, 0.005)
        local val = entity.get_prop(lp.entity, 'm_flVelocityModifier')
        local vel = menu_a ~= 0 and utils.sine_yaw(globals.framecount()/10, 0, 1) or val

        local col = colors['velocity']['Bad']:lerp(colors['velocity']['Good'], vel)
        local text = string.format("Slowed down by %.0f%%", 100-vel*100)
        local measure = vector(renderer.measure_text('cd', string.format("Slowed down by %.0f%%", 100)))
        a = utils.lerp(a, (val ~= 1 or ui.is_menu_open()) and 1 or 0, 0.03)

        utils.rectangle(self.position.x+12, self.position.y + 6, self.size.x-24, 8, 0,0,0,255*a, 2)
        utils.rectangle(self.position.x+12 + 2, self.position.y + 8, math.floor((self.size.x-24 - 4) * vel), 4, col.r,col.g,col.b,col.a*a, 5)
        renderer.text(self.position.x + self.size.x / 2, self.position.y + self.size.y - height/2-2, 255,255,255,255*a, 'cd', 0, text)
    end)

    menu.Features.velocity.on:set_event("paint", function()
        render:update()
    end)
end

--[[
local defensive do 
    local a = 0
    local vel = 0
    local render = function()
        if not lp.entity or not entity.is_alive(lp.entity) then return end
        -- local vel = entity.get_prop(lp.entity, 'm_flVelocityModifier')
        -- local vel = utils.sine_yaw(globals.servertickcount(), 0, 1)
        local col = color(255):lerp(color(220,30,50,255), exploit.get().defensive.left / 13)
        local text = "Defensive"
        renderer.text(screen.center.x, screen.size.y * 0.98, col.r,col.g,col.b,col.a, 'cd-', 0, text:upper())        
    end

    client.set_event_callback('paint', render)
end
]]

local gamesense do
    local x,y = 35,screen.size.y * 0.759
    local xy = {}
    for i=1, 9 do
        xy[i] = {35,screen.size.y * 0.759}
    end
    local render = function(e)
        local elements = {
            {"Ping Spike", refs2.ping.value and refs2.ping:get_hotkey()},
            {"Double Tap", lp.exploit == 'dt'},
            {"Fake Duck",  lp.exploit == 'fd'},
            {"Hide Shots",  lp.exploit == 'osaa'},
            {"Safe Point", refs2.safe:get()},
            {"Body Aim", refs2.baim:get()},
            {"Hit Chance", hitchance or menu.Features.gamesense.settings["Hit Chance"].container.always:get()},
            {"Min. Damage", (refs2.mdmg:get() and refs2.mdmg:get_hotkey()) or menu.Features.gamesense.settings["Min. Damage"].container.always:get()},
            {"Freestanding", menu.Antiaims.hotkeys.fs:get()},
        }
        for i=1, #elements do
            local name = elements[i][1]
            elements[i][3] = menu.Features.gamesense.settings[elements[i][1]].container.name:get() == '' and hard["gamesense"].names[elements[i][1]] or menu.Features.gamesense.settings[elements[i][1]].container.name:get()
            elements[i][2] = elements[i][2] and menu.Features.gamesense.settings[elements[i][1]].on.value
        end
        elements[8][3] = elements[8][3] .. (menu.Features.gamesense.settings["Min. Damage"].container.show.value and ': '..(refs2.mdmg:get() and refs2.mdmg:get_hotkey() and refs2.mdmg2.value or refs2.dmg.value) or '')
        elements[7][3] = elements[7][3] .. (menu.Features.gamesense.settings["Hit Chance"].container.show.value and  ': '..(hitchance and hitchance[2] or refs2.hc.value) or '')

        local y_add = 0
        if not lp.entity or not entity.is_alive(lp.entity) then return end
        local stomach_x, stomach_y, stomach_z = entity.hitbox_position(lp.entity, 3)
        local xx, yy = renderer.world_to_screen(stomach_x, stomach_y, stomach_z)

        for i, t in pairs(elements) do
                local c = colors['gamesense'][t[1]]
                local measure = vector(renderer.measure_text('+d', t[3]))
                local x1 = 29 + measure.x/2
                local y1 = screen.size.y * 0.759 - y_add - 2

                if menu.Features.gamesense.follow.value and refs2.thirdperson.value and refs2.thirdperson:get_hotkey() and xx and yy then
                    xy[i][1] = utils.lerp(xy[i][1], true and xx - 250 or 0, 0.03)
                    xy[i][2] = utils.lerp(xy[i][2], true and yy - y_add - 2 or 0, 0.03)
                else
                    xy[i][1] = utils.lerp(xy[i][1], true and x1 or 0, 0.3)
                    xy[i][2] = utils.lerp(xy[i][2], true and y1 or 0, 0.3)
                end
                if t[2] then
                    renderer.gradient(xy[i][1], xy[i][2], x1, measure.y + 4, 0, 0, 0, 25, 0,0,0,0, true)
                    renderer.gradient(xy[i][1], xy[i][2], -x1, measure.y + 4, 0, 0, 0, 25, 0,0,0,0, true)
                    renderer.text(
                        xy[i][1] - measure.x/2, xy[i][2] + 2,
                        c.r,c.g,c.b,c.a, '+d', 0,
                        t[3]
                    )
                    y_add = y_add + measure.y * 1.42
                end
        end
    end
    menu.Features.gamesense.on:set_event('paint', render)
    menu.Features.gamesense.on:set_event('indicator', function() end)
end

local debug do
    local render = function()
        local elements = {
            {"Rinnegan "..version[1]},
            {"----------------------"},
            {"Condition: "..lp.state},
        }
        y_add = 0
        for a,b in pairs(elements) do
            local text = b[1]:upper()
            local measure = vector(renderer.measure_text('-', text))
            renderer.text(100, screen.size.y*0.33   +y_add, 255,255,255,255, '-', 0, text)
            y_add = y_add + measure.y
        end
    end

    client.set_event_callback('paint', render)
end

local bomb do
    bomb = {}
    bomb.a = 0
    local render = drag.register(menu.Features.bomb.drag, vector(320, 38), "bomb", function(self)
        do
            local t = entity.get_all('CPlantedC4')
            bomb.id = t[#t]
            -- if not bomb.id then return end
            local curtime = globals.curtime()

            bomb.defused = entity.get_prop(bomb.id, 'm_bBombDefused') == 1
            bomb.is_ticking = entity.get_prop(bomb.id, 'm_bBombTicking') == 1 and not bomb.defused
            bomb.blow = entity.get_prop(bomb.id, 'm_flC4Blow') or 0
            local explode = bomb.blow
            bomb.timer = entity.get_prop(bomb.id, 'm_flTimerLength') or 40
            bomb.defuser = entity.get_prop(bomb.id, 'm_hBombDefuser')

            if bomb.defuser or bomb.defused then 
                bomb.timer = entity.get_prop(bomb.id, 'm_flDefuseLength') or 40
                bomb.blow = entity.get_prop(bomb.id, 'm_flDefuseCountDown') or 0
            end
            bomb.left = math.max(0, bomb.blow-curtime)

            local is_menu_open = ui.is_menu_open()
            if is_menu_open and not bomb.defuser and not bomb.is_ticking then
                bomb.is_ticking = true
                bomb.timer = 40
                bomb.left = utils.sine_yaw(globals.servertickcount() / 2, 0.5, 40)
            end
            bomb.percentage = bomb.left/bomb.timer
        end

        bomb.a = utils.lerp(bomb.a, ((bomb.is_ticking and bomb.percentage > 0) or is_menu_open) and 1 or 0, 0.03)
        if bomb.a <= 0 then return end

        local col = colors['bomb']['Bad']:lerp(colors['bomb']['Good'], bomb.defuser and (explode - bomb.blow >= 0 and 1 or 0) or bomb.percentage)
        utils.rectangle(self.position.x+12, self.position.y + 15, self.size.x-24, 8, 0,0,0,255*bomb.a, 2)
        utils.rectangle(self.position.x+12 + 2, self.position.y + 17, math.floor((self.size.x-24 - 4) * bomb.percentage), 4, col.r,col.g,col.b,col.a*bomb.a, 5)

        bomb.site = entity.get_prop(bomb.id, 'm_nBombSite') == 0 and "A" or "B"
        renderer.text(self.position.x+12 + math.floor((self.size.x-24 - 4) * bomb.percentage), self.position.y + 8, 255,255,255,255*bomb.a, 'cd', 0, bomb.site)
        renderer.text(self.position.x+12 + math.floor((self.size.x-24 - 4) * bomb.percentage), self.position.y + 30, 255,255,255,255*bomb.a, 'cd', 0, string.format('%.1f', bomb.left))
    end)

    menu.Features.bomb.on:set_event("paint", function()
        render:update()
    end)
end

do
    client.exec('playvol buttons\\light_power_on_switch_01 0.5')
    drag.on_config_load()
end