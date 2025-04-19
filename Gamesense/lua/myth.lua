local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w =
    client.latency,
    client.set_clan_tag,
    client.log,
    client.timestamp,
    client.userid_to_entindex,
    client.trace_line,
    client.set_event_callback,
    client.screen_size,
    client.trace_bullet,
    client.color_log,
    client.system_time,
    client.delay_call,
    client.visible,
    client.exec,
    client.eye_position,
    client.set_cvar,
    client.scale_damage,
    client.draw_hitboxes,
    client.get_cvar,
    client.camera_angles,
    client.draw_debug_text,
    client.random_int,
    client.random_float
local x, y, z, A, B, C, D, E, F, G, H, I, J, K, L, M =
    entity.get_player_resource,
    entity.get_local_player,
    entity.is_enemy,
    entity.get_bounding_box,
    entity.is_dormant,
    entity.get_steam64,
    entity.get_player_name,
    entity.hitbox_position,
    entity.get_game_rules,
    entity.get_all,
    entity.set_prop,
    entity.is_alive,
    entity.get_player_weapon,
    entity.get_prop,
    entity.get_players,
    entity.get_classname
local N, O, P, Q, R, S, T, U, V, W =
    globals.realtime,
    globals.absoluteframetime,
    globals.tickcount,
    globals.lastoutgoingcommand,
    globals.curtime,
    globals.mapname,
    globals.tickinterval,
    globals.framecount,
    globals.frametime,
    globals.maxplayers
local X, Y, Z, _, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9 =
    ui.new_slider,
    ui.new_combobox,
    ui.reference,
    ui.is_menu_open,
    ui.set_visible,
    ui.new_textbox,
    ui.new_color_picker,
    ui.set_callback,
    ui.set,
    ui.new_checkbox,
    ui.new_hotkey,
    ui.new_button,
    ui.new_multiselect,
    ui.get
local aa, ab, ac, ad, ae, af, ag, ah, ai =
    renderer.circle_outline,
    renderer.rectangle,
    renderer.gradient,
    renderer.circle,
    renderer.text,
    renderer.line,
    renderer.measure_text,
    renderer.indicator,
    renderer.world_to_screen
local aj, ak, al, am, an, ao, ap, aq, ar, as, at, au, av, aw, ax, ay, az, aA, aB, aC, aD, aE =
    math.ceil,
    math.tan,
    math.cos,
    math.sinh,
    math.pi,
    math.max,
    math.atan2,
    math.floor,
    math.sqrt,
    math.deg,
    math.atan,
    math.fmod,
    math.acos,
    math.pow,
    math.abs,
    math.min,
    math.sin,
    math.log,
    math.exp,
    math.cosh,
    math.asin,
    math.rad
local aF, aG, aH, aI = table.sort, table.remove, table.concat, table.insert
local aJ = materialsystem.find_material
local aK, aL, aM, aN, aO, aP, aQ, aR, aS, aT =
    string.find,
    string.format,
    string.gsub,
    string.len,
    string.gmatch,
    string.match,
    string.reverse,
    string.upper,
    string.lower,
    string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error =
    ipairs,
    assert,
    pairs,
    next,
    tostring,
    tonumber,
    setmetatable,
    unpack,
    type,
    getmetatable,
    pcall,
    error
local aU = ui.new_label
local aV, aW, aX, aY, aZ, a_, b0, b1, b2, b3, b4, b5, b6 = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
local b7 = require "gamesense/base64"
database.write("myth_cred", {
    username = "Rinne1337",
  })


local b9 = function()
    local ba =
        '<svg t="1723696089112" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3460" width="200" height="200"><path d="M795.52 270.08c-92.16 0-174.72 52.48-220.16 141.44-8.32 16-1.92 35.2 13.44 42.88 16 8.32 35.2 1.92 42.88-13.44 34.56-66.56 95.36-106.88 163.2-106.88 90.88 0 164.48 73.6 164.48 164.48s-73.6 164.48-164.48 164.48c-79.36 0-139.52-63.36-215.68-144-12.8-13.44-25.6-27.52-39.04-40.96-21.12-23.04-193.92-208-312.32-208C102.4 270.08 0 372.48 0 498.56s102.4 228.48 228.48 228.48c94.08 0 177.28-53.12 223.36-142.08 8.32-16 1.92-35.2-13.44-42.88-16-8.32-35.2-1.92-42.88 13.44-35.2 68.48-96 107.52-166.4 107.52-91.52 0-165.12-73.6-165.12-164.48s73.6-164.48 164.48-164.48c68.48 0 199.04 115.2 265.6 187.52l0.64 0.64c13.44 14.08 26.24 27.52 39.04 40.96 79.36 84.48 154.88 163.84 261.76 163.84 126.08 0 228.48-102.4 228.48-228.48s-102.4-228.48-228.48-228.48z" p-id="3461" fill="#ffffff"></path></svg>'
    local bb =
        '<svg t="1692112577767" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3433" id="mx_n_1692112577767" width="200" height="200"><path d="M503.466667 499.2L597.333333 405.333333l59.733334 59.733334-145.066667 145.066666-4.266667 4.266667-110.933333-110.933333 59.733333-59.733334 46.933334 55.466667zM512 170.666667c110.933333 59.733333 204.8 110.933333 298.666667 162.133333 0 213.333333-98.133333 430.933333-298.666667 563.2-200.533333-132.266667-298.666667-349.866667-298.666667-563.2C298.666667 281.6 401.066667 230.4 512 170.666667z m-55.466667 115.2l-34.133333 17.066666c-12.8 8.533333-21.333333 12.8-29.866667 17.066667-42.666667 21.333333-72.533333 38.4-102.4 55.466667 4.266667 166.4 85.333333 320 221.866667 418.133333 136.533333-98.133333 213.333333-251.733333 221.866667-418.133333-21.333333-12.8-46.933333-25.6-72.533334-38.4-25.6-12.8-110.933333-59.733333-149.333333-81.066667-17.066667 12.8-34.133333 21.333333-55.466667 29.866667z" fill="#dbdbdb" p-id="3434"></path></svg>'
    b1.notify = {}
    b1.notify.tb = {}
    aX.enabled = Z("AA", "Anti-aimbot angles", "Enabled")
    aX.pitch = {Z("AA", "Anti-aimbot angles", "Pitch")}
    aX.yaw_base = Z("AA", "Anti-aimbot angles", "Yaw base")
    aX.yaw = {Z("AA", "Anti-aimbot angles", "Yaw")}
    aX.yaw_jitter = {Z("AA", "Anti-aimbot angles", "Yaw jitter")}
    aX.body_yaw = {Z("AA", "Anti-aimbot angles", "Body yaw")}
    aX.freestanding_body_yaw = Z("AA", "Anti-aimbot angles", "Freestanding body yaw")
    aX.edge_yaw = Z("AA", "Anti-aimbot angles", "Edge yaw")
    aX.freestanding = {Z("AA", "Anti-aimbot angles", "Freestanding")}
    aX.roll = Z("AA", "Anti-aimbot angles", "Roll")
    aX.slow_motion = {Z("AA", "Other", "Slow motion")}
    aX.leg_movement = Z("AA", "Other", "Leg movement")
    aX.hide_shots = {Z("AA", "Other", "On shot anti-aim")}
    aX.fake_peek = {Z("AA", "Other", "Fake peek")}
    aX.fake_lag = Z("AA", "Fake lag", "Enabled")
    aX.fake_lag_limit = Z("AA", "Fake lag", "Limit")
    aX.anti_untrusted = Z("MISC", "Settings", "Anti-untrusted")
    aX.fakeduck = Z("Rage", "Other", "Duck peek assist")
    aX.thirdperson = {Z("VISUALS", "Effects", "Force third person (alive)")}
    aX.doubletap = {Z("RAGE", "Aimbot", "Double tap")}
    aX.force_body_aim = Z("RAGE", "Aimbot", "Force body aim")
    aX.force_safe_point = Z("RAGE", "Aimbot", "Force safe point")
    aX.ping_spike = {Z("MISC", "miscellaneous", "ping spike")}
    aX.menu_color = Z("MISC", "Settings", "Menu color")
    aX.quick_peek_assist = {Z("RAGE", "Other", "Quick peek assist")}
    aX.fake_enable = {Z("AA", "Fake lag", "Enabled")}
    aX.fake_amount = Z("AA", "Fake lag", "Amount")
    aX.fake_variance = Z("AA", "Fake lag", "Variance")
    aX.fake_limit = Z("AA", "Fake lag", "Limit")
    b0.new = function(bc, bd, be, bf)
        bf = bf or nil
        if type(bc) ~= "number" then
            return
        end
        table.insert(be[type(ui.get(bc))], bc)
        if bf ~= nil then
            table.insert(bf[type(ui.get(bc))], bc)
        end
        table.insert(bd, bc)
        return bc
    end
    b0.load = function(be, bg)
        if bg == nil then
            return
        end
        local bh = function(bi, bj)
            local bk = {}
            for bl in string.gmatch(bi, "([^" .. bj .. "]+)") do
                bk[#bk + 1] = string.gsub(bl, "\n", "")
            end
            return bk
        end
        local bm = function(bl)
            if bl == "true" or bl == "false" then
                return bl == "true"
            else
                return bl
            end
        end
        local bk = bh(b7.decode(bg and bg or nil, "base64"), "|")
        local bn = 1
        for bo, bp in pairs(be["number"]) do
            if bk[bn] == nil then
                return
            end
            ui.set(bp, tonumber(bk[bn]))
            bn = bn + 1
        end
        for bo, bp in pairs(be["string"]) do
            if bk[bn] == nil then
                return
            end
            ui.set(bp, bk[bn])
            bn = bn + 1
        end
        for bo, bp in pairs(be["boolean"]) do
            if bk[bn] == nil then
                return
            end
            ui.set(bp, bm(bk[bn]))
            bn = bn + 1
        end
        for bo, bp in pairs(be["table"]) do
            if bk[bn] == nil then
                return
            end
            ui.set(bp, bh(bk[bn], ","))
            bn = bn + 1
        end
    end
    b0.exp = function(be)
        local bq = ""
        local br = function(bs)
            local bl = ""
            for bt = 1, #bs do
                bl = bl .. bs[bt] .. (bt == #bs and "" or ",")
            end
            if bl == "" then
                bl = "-"
            end
            return bl
        end
        for bo, bp in pairs(be["number"]) do
            bq = bq .. tostring(ui.get(bp)) .. "|"
        end
        for bo, bp in pairs(be["string"]) do
            bq = bq .. ui.get(bp) .. "|"
        end
        for bo, bp in pairs(be["boolean"]) do
            bq = bq .. tostring(ui.get(bp)) .. "|"
        end
        for bo, bp in pairs(be["table"]) do
            bq = bq .. br(ui.get(bp)) .. "|"
        end
        return b7.encode(bq)
    end
    b0.table_contain = function(bu, bv)
        for bt = 1, #bu do
            if bu[bt] == bv then
                return true
            end
        end
        return false
    end
    aZ.lerp = function(self, bw, bx, by)
        if type(bw) == "table" and type(bx) == "table" then
            return {self:lerp(bw[1], bx[1], by), self:lerp(bw[2], bx[2], by), self:lerp(bw[3], bx[3], by)}
        end
        return bw + (bx - bw) * by
    end
    aZ.console = function(self, ...)
        for bt, bz in ipairs({...}) do
            if type(bz[1]) == "table" and type(bz[2]) == "table" and type(bz[3]) == "string" then
                for bA = 1, #bz[3] do
                    local bB = self:lerp(bz[1], bz[2], bA / #bz[3])
                    j(bB[1], bB[2], bB[3], bz[3]:sub(bA, bA) .. "\0")
                end
            elseif type(bz[1]) == "table" and type(bz[2]) == "string" then
                j(bz[1][1], bz[1][2], bz[1][3], bz[2] .. "\0")
            end
        end
    end
    aZ.text = function(self, ...)
        local bC = false
        local bD = 255
        local bE = ""
        for bt, bz in ipairs({...}) do
            if type(bz) == "boolean" then
                bC = bz
            elseif type(bz) == "number" then
                bD = bz
            elseif type(bz) == "string" then
                bE = bE .. bz
            elseif type(bz) == "table" then
                if type(bz[1]) == "table" and type(bz[2]) == "string" then
                    bE = bE .. ("\a%02x%02x%02x%02x"):format(bz[1][1], bz[1][2], bz[1][3], bD) .. bz[2]
                elseif type(bz[1]) == "table" and type(bz[2]) == "table" and type(bz[3]) == "string" then
                    for bA = 1, #bz[3] do
                        local bF = self:lerp(bz[1], bz[2], bA / #bz[3])
                        bE = bE .. ("\a%02x%02x%02x%02x"):format(bF[1], bF[2], bF[3], bD) .. bz[3]:sub(bA, bA)
                    end
                end
            end
        end
        return ("%s\a%s%02x"):format(bE, bC and "cdcdcd" or "ffffff", bD)
    end
    aZ.log = function(self, ...)
        for bt, bz in ipairs({...}) do
            if type(bz) == "table" then
                if type(bz[1]) == "table" then
                    if type(bz[2]) == "string" then
                        self:console({bz[1], bz[1], bz[2]})
                        if bz[3] then
                            self:console({{255, 255, 255}, "\n"})
                        end
                    elseif type(bz[2]) == "table" then
                        self:console({bz[1], bz[2], bz[3]})
                        if bz[4] then
                            self:console({{255, 255, 255}, "\n"})
                        end
                    end
                elseif type(bz[1]) == "string" then
                    self:console({{205, 205, 205}, bz[1]})
                    if bz[2] then
                        self:console({{255, 255, 255}, "\n"})
                    end
                end
            end
        end
    end
    aZ.gradient_text = function(bG, bH, bI, bJ, bK, bL, bM, bN, bO)
        local bP = ""
        local bQ = #bO - 1
        local bR = (bK - bG) / bQ
        local bS = (bL - bH) / bQ
        local bT = (bM - bI) / bQ
        local bU = (bN - bJ) / bQ
        for bt = 1, bQ + 1 do
            bP = bP .. ("\a%02x%02x%02x%02x%s"):format(bG, bH, bI, bJ, bO:sub(bt, bt))
            bG = bG + bR
            bH = bH + bS
            bI = bI + bT
            bJ = bJ + bU
        end
        return bP
    end
    aZ.fade_text = function(bG, bH, bI, bJ, bK, bL, bM, bN, bV)
        local bW = globals.realtime() / 2 % 1.2 * 2 - 1.2
        local bP = ""
        if bV == nil then
            return
        end
        for bX = 1, #bV do
            local bY = bV:sub(bX, bX)
            local bZ = bX / #bV
            local b_ = bZ - bW
            if b_ >= 0 and b_ <= 1.4 then
                if b_ > 0.7 then
                    b_ = 1.4 - b_
                end
                local c0, c1, c2, c3 = bK - bG, bL - bH, bM - bI
                bG = bG + c0 * b_ / 0.8
                bH = bH + c1 * b_ / 0.8
                bI = bI + c2 * b_ / 0.8
            end
            bP = bP .. ("\a%02x%02x%02x%02x%s"):format(bG, bH, bI, bJ, bV:sub(bX, bX))
        end
        return bP
    end
    local c4 = function()
        if not ui.get(aX.doubletap[1]) or not ui.get(aX.doubletap[2]) then
            return false
        end
        if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then
            return
        end
        local c5 = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
        if c5 == nil then
            return false
        end
        local c6 = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
        local c7 = entity.get_prop(c5, "m_flNextPrimaryAttack")
        if c7 == nil then
            return
        end
        local c8 = c7 + 0.5
        if c6 == nil or c8 == nil then
            return false
        end
        return c6 - globals.curtime() < 0 and c8 - globals.curtime() < 0
    end
    local c9 = function(...)
        local ca = {...}
        aZ:log(
            {{235, 42, 142}, {186, 198, 212}, "Myth"},
            {{100, 100, 100}, " <=> "},
            {{255, 255, 255}, string.format(unpack(ca)), true}
        )
    end
    c9("Started your Myth!")
    aV.build = "Release"
    aZ:log(
        {{235, 42, 142}, {186, 198, 212}, "Myth"},
        {{100, 100, 100}, " <=> "},
        {{255, 255, 255}, "Myth Anti-aimbot angles system V.1"},
        {{144, 194, 54}, "._C"},
        {{205, 205, 205}, " edition:"},
        {{239, 86, 86}, " " .. aV.build, true}
    )
    c9("Welcome BACK! " .. "Rinne")
    b2.register_data = {}
    b2.register_ui = {["number"] = {}, ["string"] = {}, ["boolean"] = {}, ["table"] = {}}
    b2.register_aa = {["number"] = {}, ["string"] = {}, ["boolean"] = {}, ["table"] = {}}
    local cb, cc = "aa", "anti-aimbot angles"
    local cd, ce = "aa", "other"
    local cf, cg = "aa", "Fake lag"
    b3.c_og = b0.new(aU(cb, cc, "\a6E6868FF#hide og  ▲"), b2.register_data, b2.register_ui)
    b3.c_og_box = b0.new(a5(cb, cc, "=========================================="), b2.register_data, b2.register_ui)
    b3.spacing = aU(cb, cc, " ")
    b3.cnameS =
        b0.new(
        aU(cb, cc, "\aFF105DFFMyth\a6E6868FF.lua - \a774CFFFF" .. aV.build .. " - \a96C83CFF" .. "Rinne"),
        b2.register_data,
        b2.register_ui
    )
    b3.cname2 = b0.new(aU(cb, cc, "\a6E6868FF£- Born to be a retard."), b2.register_data, b2.register_ui)
    b3.spacingA = aU(cd, ce, " ")
    b3.spacingB = aU(cd, ce, " ")
    b3.spacingC = aU(cd, ce, " ")
    b3.spacingA = aU(cd, ce, " ")
    b3.page_slider =
        b0.new(
        X(cd, ce, " ", 0, 3, 0, true, "", 1, {[0] = "init.", [1] = "anti-aim.", [2] = "func.", [3] = "up.inf."}),
        b2.register_data,
        b2.register_ui
    )
    b3.cname =
        b0.new(
        aU(
            cd,
            ce,
            "               \aFF105DFFMyth\a6E6868FF.lua - \a774CFFFF" .. aV.build .. "\aFFFFFFC8 - Page \a6E6868FFMain"
        ),
        b2.register_data,
        b2.register_ui
    )
    local ch = {"stand", "move", "duck", "slow-motion", "air", "air + duck"}
    b3.a_enable = b0.new(a5(cb, cc, "Boost anti-aimbot angles"), b2.register_data, b2.register_ui)
    b3.a_state = b0.new(Y(cb, cc, "states", ch), b2.register_data, b2.register_ui)
    b3.builder = {}
    b3.pos_x = b0.new(X("LUA", "B", "\nSaved Position X INDICATOR", 0, 10000, 10), b2.register_data, b2.register_ui)
    b3.pos_y = b0.new(X("LUA", "B", "\nSaved Position Y INDICATOR", 0, 10000, 10), b2.register_data, b2.register_ui)
    local ci = {}
    for bA, bz in pairs(ch) do
        ci[bA] = "\a6E6868FF#" .. ch[bA] .. ""
        b3.builder[bA] = {
            defen_option = {
                b0.new(
                    Y(cb, cc, ci[bA] .. " should defen.?", {"off", "adp.", "force"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                )
            },
            pitch_defn = {
                b0.new(
                    Y(
                        cb,
                        cc,
                        ci[bA] .. " \aE5D841FF*pitch",
                        {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"}
                    ),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " pd", -89, 89, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                )
            },
            yaw_defn = {
                b0.new(
                    Y(cb, cc, ci[bA] .. " \aE5D841FF*yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    Y(cb, cc, ci[bA] .. " \aE5D841FF*extend yaw", {"off", "traditional", "extend jitter"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " sA", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " tr. lefts", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " tr. rights", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " ex. values", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                )
            },
            pitch = {
                b0.new(
                    Y(cb, cc, ci[bA] .. " pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " p", -89, 89, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                )
            },
            yaw = {
                b0.new(
                    Y(cb, cc, ci[bA] .. " yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    Y(cb, cc, ci[bA] .. " extend yaw", {"off", "traditional", "extend jitter"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " a", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " tr. leftd", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " tr. rightd", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " ex. valued", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                )
            },
            yaw_jitter = {
                b0.new(
                    Y(cb, cc, ci[bA] .. " yaw jitter", {"Off", "Offset", "Center", "Random", "Skitter"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    Y(cb, cc, ci[bA] .. " extend func.", {"off", "traditional", "extend jitter"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " a.", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " tr. leftp", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " tr. rightp", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " ex. valuep", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                )
            },
            body_yaw = {
                b0.new(
                    Y(cb, cc, ci[bA] .. " body yaw", {"Off", "Opposite", "Jitter", "Static"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    Y(cb, cc, ci[bA] .. " optional body", {"off", "traditional", "extend", "adaptive"}),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " sAp", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " tr. min", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " tr. max", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " ex. max", -180, 180, 0, true, "°"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                ),
                b0.new(
                    X(cb, cc, ci[bA] .. " adp. relay", -27, 34, 0, true, "*"),
                    b2.register_data,
                    b2.register_ui,
                    b2.register_aa
                )
            },
            fake_yaw_limit = b0.new(
                X(cb, cc, ci[bA] .. " fake yaw limit", 0, 60, 0, true, "°"),
                b2.register_data,
                b2.register_ui,
                b2.register_aa
            )
        }
    end
    b3.p2_spacingA = b0.new(aU(cb, cc, "\a6E6868FF#"), b2.register_data, b2.register_ui)
    b3.p2_cnameA = b0.new(aU(cb, cc, "\a6E6868FFkey sets."), b2.register_data, b2.register_ui)
    b3.p2_spacingB = b0.new(aU(cb, cc, " "), b2.register_data, b2.register_ui)
    b3.manual_options =
        b0.new(a8(cb, cc, "manual options", {"f. static", "f. straight"}), b2.register_data, b2.register_ui)
    b3.manual_left = {false, a6(cb, cc, "manual left")}
    b3.manual_right = {false, a6(cb, cc, "manual right")}
    b3.manual_reset = {false, a6(cb, cc, "manual reset")}
    b3.legit_aa = a6(cb, cc, "antiaim on use")
    b3.freestanding = {false, a6(cb, cc, "freestanding")}
    b3.edge_yaw = {false, a6(cb, cc, "edge yaw")}
    b3.p2_spacingE = b0.new(aU(cb, cc, " "), b2.register_data, b2.register_ui)
    b3.p2_spacingC = b0.new(aU(cb, cc, "\a6E6868FF#"), b2.register_data, b2.register_ui)
    b3.p2_cnameB = b0.new(aU(cb, cc, "\a6E6868FFui."), b2.register_data, b2.register_ui)
    b3.p2_spacingD = b0.new(aU(cb, cc, " "), b2.register_data, b2.register_ui)
    b3.indicator =
        b0.new(
        a8(
            cb,
            cc,
            "should render.?",
            {"manual indicator", "-#1v1 helper", "center", "notify", "defensive tracker", "..."},
            "notify"
        ),
        b2.register_data,
        b2.register_ui
    )
    b3.arrow_distance = b0.new(X(cb, cc, " distance", 10, 100, 15, true, "pt."), b2.register_data, b2.register_ui)
    b3.noti_rgb = b0.new(a5(cb, cc, "A button that boost ur antiaim", false), b2.register_data, b2.register_ui)
    b3.noti_rgb_a = b0.new(a5(cb, cc, "ExTeNdEd RgB", false), b2.register_data, b2.register_ui)
    b3.noti_time = b0.new(X(cb, cc, "RGB Timer", 5, 500, 20, true, "s", 0.01), b2.register_data, b2.register_ui)
    b3.p2_spacingF = b0.new(aU(cb, cc, " "), b2.register_data, b2.register_ui)
    b3.th_color_cname = b0.new(aU(cb, cc, "change 1v1 helper color.?"), b2.register_data, b2.register_ui)
    b3.th_color =
        b0.new(a2(cb, cc, "change 1v1 helper  color.?_color", 235, 42, 142, 255), b2.register_data, b2.register_ui)
    b3.center_color_cname = b0.new(aU(cb, cc, "change center color.?"), b2.register_data, b2.register_ui)
    b3.center_color =
        b0.new(a2(cb, cc, "change center color.?_color", 235, 42, 142, 255), b2.register_data, b2.register_ui)
    b3.arrow_color_cname = b0.new(aU(cb, cc, "change arrows color.?"), b2.register_data, b2.register_ui)
    b3.arrow_color =
        b0.new(a2(cb, cc, "change arrows color.?_color", 235, 42, 142, 255), b2.register_data, b2.register_ui)
    b3.noti_color_cname = b0.new(aU(cb, cc, "change notify color.?"), b2.register_data, b2.register_ui)
    b3.noti_color =
        b0.new(a2(cb, cc, "change notify color.?_color", 235, 42, 142, 255), b2.register_data, b2.register_ui)
    b3.defn_color_cname = b0.new(aU(cb, cc, "change defensive tracker color.?"), b2.register_data, b2.register_ui)
    b3.defn_color =
        b0.new(
        a2(cb, cc, "change defensive tracker color.?_color", 235, 42, 142, 255),
        b2.register_data,
        b2.register_ui
    )
    b3.p2_spacingG = b0.new(aU(cb, cc, " "), b2.register_data, b2.register_ui)
    b3.p2_spacingH = b0.new(aU(cb, cc, "\a6E6868FF#"), b2.register_data, b2.register_ui)
    b3.p2_cnameC = b0.new(aU(cb, cc, "\a6E6868FFmisc."), b2.register_data, b2.register_ui)
    b3.p2_spacingI = b0.new(aU(cb, cc, " "), b2.register_data, b2.register_ui)
    b3.features =
        b0.new(a8(cb, cc, "should enable.?", {"anti-knife", "anim. breaker", "..."}), b2.register_data, b2.register_ui)
    b3.m_antidis = b0.new(X(cb, cc, " anti-distance", 200, 600, 280, true, "m"), b2.register_data, b2.register_ui)
    b3.m_animbreak = b0.new(a8(cb, cc, " anims", {"in air", "on land", "leg fucker"}), b2.register_data, b2.register_ui)
    b5.visible = function()
        local cj = Z("MISC", "Settings", "Menu color")
        local ck = function(cl, cm, cn, co)
            local bE, bF, cp
            local bt = aq(cl * 6)
            local cq = cl * 6 - bt
            local bA = cn * (1 - cm)
            local bB = cn * (1 - cq * cm)
            local b3 = cn * (1 - (1 - cq) * cm)
            bt = bt % 6
            if bt == 0 then
                bE, bF, cp = cn, b3, bA
            elseif bt == 1 then
                bE, bF, cp = bB, cn, bA
            elseif bt == 2 then
                bE, bF, cp = bA, cn, b3
            elseif bt == 3 then
                bE, bF, cp = bA, bB, cn
            elseif bt == 4 then
                bE, bF, cp = b3, bA, cn
            elseif bt == 5 then
                bE, bF, cp = cn, bA, bB
            end
            return bE * 255, bF * 255, cp * 255, co * 255
        end
        local cr = a9(b3.noti_time) / 10
        local bk = N() % cr / cr
        local cs = 1 - math.abs(bk * 2 - 1)
        local ct, cu, cv = ck(cs, 1, 1, 1)
        if a9(b3.noti_rgb) then
            a4(cj, ct, cu, cv, 255)
        end
        local cw = aZ.fade_text(61, 61, 61, 255, 200, 200, 200, 255, "legend")
        a4(b3.cname2, "\a6E6868FF£- Born to be a " .. cw .. ".")
        if a9(b3.c_og_box) then
            a4(b3.c_og, "\a6E6868FF#hide og  ▲")
        else
            a4(b3.c_og, "\a6E6868FF#hide og  ▼")
        end
        if a9(b3.page_slider) == 0 then
            a4(
                b3.cname,
                "               \aFF105DFFMyth\a6E6868FF.lua - \a774CFFFF" ..
                    aV.build .. "\aFFFFFFC8 - Page \a6E6868FFMain"
            )
        elseif a9(b3.page_slider) == 1 then
            a4(
                b3.cname,
                "               \aFF105DFFMyth\a6E6868FF.lua - \a774CFFFF" ..
                    aV.build .. "\aFFFFFFC8 - Page \a6E6868FF1"
            )
        elseif a9(b3.page_slider) == 2 then
            a4(
                b3.cname,
                "               \aFF105DFFMyth\a6E6868FF.lua - \a774CFFFF" ..
                    aV.build .. "\aFFFFFFC8 - Page \a6E6868FF2"
            )
        elseif a9(b3.page_slider) == 3 then
            a4(
                b3.cname,
                "               \aFF105DFFMyth\a6E6868FF.lua - \a774CFFFF" ..
                    aV.build .. "\aFFFFFFC8 - Page \a6E6868FF3"
            )
        end
        local cx = function(cy)
            a0(aX.enabled, cy)
            a0(aX.pitch[1], cy)
            a0(aX.pitch[2], cy)
            a0(aX.yaw_base, cy)
            a0(aX.yaw[1], cy)
            a0(aX.yaw[2], cy)
            a0(aX.yaw_jitter[1], cy)
            a0(aX.yaw_jitter[2], cy)
            a0(aX.body_yaw[1], cy)
            a0(aX.body_yaw[2], cy)
            a0(aX.freestanding_body_yaw, cy)
            a0(aX.edge_yaw, cy)
            a0(aX.freestanding[1], cy)
            a0(aX.freestanding[2], cy)
            a0(aX.roll, cy)
        end
        if not a9(b3.a_enable) then
            cx(a9(b3.c_og_box))
        end
        local cz, cA, cB, cC =
            a9(b3.page_slider) == 0,
            a9(b3.page_slider) == 1,
            a9(b3.page_slider) == 2,
            a9(b3.page_slider) == 3
        a0(b3.cnameS, cz)
        a0(b3.cname2, cz)
        a0(b3.a_enable, cA)
        local cD = a9(b3.a_enable) and cA
        a0(b3.a_state, cD)
        for bA, bz in pairs(ch) do
            local cE = cD and a9(b3.a_state) == ch[bA]
            a0(b3.builder[bA].defen_option[1], cE)
            local cF = cE and a9(b3.builder[bA].defen_option[1]) ~= "off"
            a0(b3.builder[bA].pitch_defn[1], cF)
            a0(b3.builder[bA].pitch_defn[2], cF and a9(b3.builder[bA].pitch_defn[1]) == "Custom")
            a0(b3.builder[bA].yaw_defn[1], cF)
            a0(b3.builder[bA].yaw_defn[2], cF and a9(b3.builder[bA].yaw_defn[1]) ~= "Off")
            a0(
                b3.builder[bA].yaw_defn[3],
                cF and a9(b3.builder[bA].yaw_defn[2]) == "off" and a9(b3.builder[bA].yaw_defn[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].yaw_defn[4],
                cF and a9(b3.builder[bA].yaw_defn[2]) == "traditional" and a9(b3.builder[bA].yaw_defn[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].yaw_defn[5],
                cF and a9(b3.builder[bA].yaw_defn[2]) == "traditional" and a9(b3.builder[bA].yaw_defn[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].yaw_defn[6],
                cF and a9(b3.builder[bA].yaw_defn[2]) == "extend jitter" and a9(b3.builder[bA].yaw_defn[1]) ~= "Off"
            )
            a0(b3.builder[bA].pitch[1], cE)
            a0(b3.builder[bA].pitch[2], cE and a9(b3.builder[bA].pitch[1]) == "Custom")
            a0(b3.builder[bA].yaw[1], cE)
            a0(b3.builder[bA].yaw[2], cE and a9(b3.builder[bA].yaw[1]) ~= "Off")
            a0(b3.builder[bA].yaw[3], cE and a9(b3.builder[bA].yaw[2]) == "off" and a9(b3.builder[bA].yaw[1]) ~= "Off")
            a0(
                b3.builder[bA].yaw[4],
                cE and a9(b3.builder[bA].yaw[2]) == "traditional" and a9(b3.builder[bA].yaw[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].yaw[5],
                cE and a9(b3.builder[bA].yaw[2]) == "traditional" and a9(b3.builder[bA].yaw[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].yaw[6],
                cE and a9(b3.builder[bA].yaw[2]) == "extend jitter" and a9(b3.builder[bA].yaw[1]) ~= "Off"
            )
            a0(b3.builder[bA].yaw_jitter[1], cE)
            a0(b3.builder[bA].yaw_jitter[2], cE and a9(b3.builder[bA].yaw_jitter[1]) ~= "Off")
            a0(
                b3.builder[bA].yaw_jitter[3],
                cE and a9(b3.builder[bA].yaw_jitter[2]) == "off" and a9(b3.builder[bA].yaw_jitter[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].yaw_jitter[4],
                cE and a9(b3.builder[bA].yaw_jitter[2]) == "traditional" and a9(b3.builder[bA].yaw_jitter[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].yaw_jitter[5],
                cE and a9(b3.builder[bA].yaw_jitter[2]) == "traditional" and a9(b3.builder[bA].yaw_jitter[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].yaw_jitter[6],
                cE and a9(b3.builder[bA].yaw_jitter[2]) == "extend jitter" and a9(b3.builder[bA].yaw_jitter[1]) ~= "Off"
            )
            a0(b3.builder[bA].body_yaw[1], cE)
            a0(b3.builder[bA].body_yaw[2], cE and a9(b3.builder[bA].body_yaw[1]) ~= "Off")
            a0(
                b3.builder[bA].body_yaw[3],
                cE and a9(b3.builder[bA].body_yaw[2]) == "off" and a9(b3.builder[bA].body_yaw[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].body_yaw[4],
                cE and a9(b3.builder[bA].body_yaw[2]) == "traditional" and a9(b3.builder[bA].body_yaw[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].body_yaw[5],
                cE and a9(b3.builder[bA].body_yaw[2]) == "traditional" and a9(b3.builder[bA].body_yaw[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].body_yaw[6],
                cE and a9(b3.builder[bA].body_yaw[2]) == "extend" and a9(b3.builder[bA].body_yaw[1]) ~= "Off"
            )
            a0(
                b3.builder[bA].body_yaw[7],
                cE and a9(b3.builder[bA].body_yaw[2]) == "adaptive" and a9(b3.builder[bA].body_yaw[1]) ~= "Off"
            )
            a0(b3.builder[bA].fake_yaw_limit, cE)
        end
        a0(b3.manual_options, cB)
        a0(b3.manual_left[2], cB)
        a0(b3.manual_right[2], cB)
        a0(b3.manual_reset[2], cB)
        a0(b3.legit_aa, cB)
        a0(b3.freestanding[2], cB)
        a0(b3.edge_yaw[2], cB)
        a0(b3.p2_cnameA, cB)
        a0(b3.p2_spacingA, cB)
        a0(b3.p2_spacingB, cB)
        a0(b3.p2_cnameB, cB)
        a0(b3.p2_cnameC, cB)
        a0(b3.p2_spacingC, cB)
        a0(b3.p2_spacingD, cB)
        a0(b3.p2_spacingE, cB)
        a0(b3.p2_spacingF, cB)
        a0(b3.p2_spacingG, cB)
        a0(b3.p2_spacingH, cB)
        a0(b3.p2_spacingI, cB)
        a0(b3.indicator, cB)
        a0(b3.arrow_distance, cB and b0.table_contain(a9(b3.indicator), "manual indicator"))
        a0(b3.noti_rgb, cB)
        a0(b3.noti_rgb, cB)
        a0(b3.noti_time, cB and a9(b3.noti_rgb))
        a0(b3.noti_rgb_a, cB and a9(b3.noti_rgb))
        a0(b3.th_color_cname, cB and b0.table_contain(a9(b3.indicator), "-#1v1 helper"))
        a0(b3.th_color, cB and b0.table_contain(a9(b3.indicator), "-#1v1 helper"))
        a0(b3.center_color_cname, cB and b0.table_contain(a9(b3.indicator), "center"))
        a0(b3.center_color, cB and b0.table_contain(a9(b3.indicator), "center"))
        a0(b3.arrow_color_cname, cB and b0.table_contain(a9(b3.indicator), "manual indicator"))
        a0(b3.arrow_color, cB and b0.table_contain(a9(b3.indicator), "manual indicator"))
        a0(b3.noti_color_cname, cB and b0.table_contain(a9(b3.indicator), "notify"))
        a0(b3.noti_color, cB and b0.table_contain(a9(b3.indicator), "notify"))
        a0(b3.defn_color_cname, cB and b0.table_contain(a9(b3.indicator), "defensive tracker"))
        a0(b3.defn_color, cB and b0.table_contain(a9(b3.indicator), "defensive tracker"))
        a0(b3.features, cB)
        a0(b3.m_antidis, cB and b0.table_contain(a9(b3.features), "anti-knife"))
        a0(b3.m_animbreak, cB and b0.table_contain(a9(b3.features), "anim. breaker"))
    end
    b5.visible()
    local cG = ui.new_slider("lua", "b", "_temp_states", 0, 3, 0)
    a0(cG, false)
    local J, K = entity.get_player_weapon, entity.get_prop
    local cH = 0
    local cI = function(co)
        local cJ = bit.band(K(co, "m_fFlags"), 1)
        if cJ == 1 then
            cH = cH + 1
        else
            cH = 0
        end
        return cH > 8
    end
    local cK = function(cL, cM, cN, cO, cP, cQ)
        return math.sqrt((cO - cL) ^ 2 + (cP - cM) ^ 2 + (cQ - cN) ^ 2)
    end
    a_.get_dist_to_ety = function(cR, cS, cT, cU, cV, cW)
        return cK(cR, cS, cT, cU, cV, cW)
    end
    a_.is_scoped = function(a_)
        if J(a_) == nil then
            return
        end
        return K(J(a_), "m_zoomLevel") == 1 or K(J(a_), "m_zoomLevel") == 2
    end
    a_.is_slowdown = function(co)
        return K(co, "m_flVelocityModifier") ~= 1
    end
    a_.get_velocity = function(co)
        local cX, cY, cZ = K(co, "m_vecVelocity")
        return math.sqrt(cX ^ 2 + cY ^ 2)
    end
    a_.is_static = function(co)
        return a_.get_velocity(co) < 2 and cI(co)
    end
    a_.is_move = function(co)
        return a_.get_velocity(co) > 10 and cI(co)
    end
    a_.is_duck = function(co)
        local c_ = K(co, "m_flDuckAmount") > 0.8
        return c_ and cI(co)
    end
    a_.is_slowmotion = function(co)
        return ui.get(aX.slow_motion[1]) and ui.get(aX.slow_motion[2])
    end
    a_.is_air = function(co)
        return bit.band(K(co, "m_fFlags"), 1) == 0 and cH <= 6
    end
    a_.is_airduck = function(co)
        return a_.is_air(co) and K(co, "m_flDuckAmount") > 0.8 and cH <= 6
    end
    local d0 = {dir = 0, m_states = 0, left = false, right = false, back = false}
    local cG = ui.new_slider("lua", "b", "_aafunc_states", 0, 3, 1)
    ui.set_visible(cG, false)
    aY.get_direct = function(...)
        local d1 = {...}
        for bA, bz in pairs(d1) do
            if type(bz) ~= "number" then
                print("args should be menu elements")
                return
            end
        end
        ui.set(d1[1], "On hotkey")
        ui.set(d1[2], "On hotkey")
        ui.set(d1[3], "On hotkey")
        ui.set(aX.freestanding[2], "Always on")
        local d2, d3 = ui.get(d1[4]), ui.get(d1[5])
        ui.set(aX.freestanding[1], d2)
        ui.set(aX.edge_yaw, d3)
        m_states = ui.get(cG)
        left, right, back = ui.get(d1[1]), ui.get(d1[2]), ui.get(d1[3])
        if left == d0.left and right == d0.right and back == d0.back then
            return
        end
        d0.left, d0.right, d0.back = left, right, back
        if left and m_states == 1 or right and m_states == 2 or back and m_states == 3 then
            ui.set(cG, 0)
            return
        end
        if left and m_states ~= 1 then
            ui.set(cG, 1)
        end
        if right and m_states ~= 2 then
            ui.set(cG, 2)
        end
        if back and m_states ~= 3 then
            ui.set(cG, 3)
        end
        d0.dir = ui.get(cG) == 0 and 0 or ui.get(cG) == 1 and -90 or ui.get(cG) == 2 and 90 or ui.get(cG) == 3 and 0
        return d0.dir
    end
    aY.get_dir_data = function()
        return d0.dir
    end
    aY.normalize_angle = function(d4)
        while d4 > 180 do
            d4 = d4 - 360
        end
        while d4 < -180 do
            d4 = d4 + 360
        end
        return d4
    end
    aY.get_sIndex = function(co, d5)
        if a_.is_airduck(co) then
            return 6
        elseif a_.is_air(co) then
            return 5
        elseif a_.is_slowmotion(co) then
            return 4
        elseif a_.is_duck(co) then
            return 3
        elseif a_.is_move(co) and not a_.is_slowmotion(co) then
            return 2
        elseif a_.is_static(co) and not a_.is_slowmotion(co) then
            return 1
        else
            return 6
        end
    end
    local d6 = false
    local d7 = function(b8)
        if entity.get_local_player() == nil then
            return
        end
        local d8 = ui.get(aX.body_yaw[2])
        return math.floor(
            math.min(
                math.abs(b8),
                entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * math.abs(b8) * 2 - math.abs(b8)
            )
        ) > 0
    end
    aY.tr_jitter = function(d9, cl, b8)
        return d6 and d9 or cl
    end
    aY.ex_jitter = function(d9, cl, cm, b8)
        d9 = d9 + cm
        cl = cl + cm
        return d6 and aY.normalize_angle(d9) or aY.normalize_angle(cl)
    end
    aY.on_use = function(da)
        local cK = function(cL, cM, cN, cO, cP, cQ)
            return math.sqrt((cO - cL) ^ 2 + (cP - cM) ^ 2 + (cQ - cN) ^ 2)
        end
        local db = function(dc)
            local dd = entity.get_all("CC4")[1]
            return dd ~= nil and entity.get_prop(dd, "m_hOwnerEntity") == dc
        end
        local de = entity.get_local_player()
        local df = 100
        local dd = entity.get_all("CPlantedC4")[1]
        local dg, dh, di = K(dd, "m_vecOrigin")
        if dg ~= nil then
            local dj, dk, dl = K(de, "m_vecOrigin")
            df = cK(dg, dh, di, dj, dk, dl)
        end
        local dm = K(de, "m_iTeamNum")
        local dn = dm == 3 and df < 62
        local dp = K(de, "m_bInBombZone")
        local dq = db(de)
        local dr = dp ~= 0 and dm == 2 and dq and false
        local ds, dt, du = o()
        local dv, dw = t()
        local dx = az(aE(dv))
        local dy = al(aE(dv))
        local dz = az(aE(dw))
        local dA = al(aE(dw))
        local dB = {dy * dA, dy * dz, -dx}
        local dC, dD = f(de, ds, dt, du, ds + dB[1] * 8192, dt + dB[2] * 8192, du + dB[3] * 8192)
        local dE = true
        local dF = {"CWorld", "CCSPlayer", "CFuncBrush"}
        if dD ~= nil then
            for bt = 0, #dF do
                if entity.get_classname(dD) == dF[bt] then
                    dE = false
                end
            end
        end
        if not dE and not dr and not dn then
            da.in_use = 0
        end
    end
    b6.update_manual = function()
        a4(b3.manual_left[2], "On hotkey")
        a4(b3.manual_right[2], "On hotkey")
        a4(b3.manual_reset[2], "On hotkey")
        a0(cG, false)
        local dG = a9(cG)
        local dH, dI, dJ = a9(b3.manual_left[2]), a9(b3.manual_right[2]), a9(b3.manual_reset[2])
        local dK = a9(b3.edge_yaw[2])
        a4(aX.edge_yaw, dK and true or false)
        if a9(b3.freestanding[2]) then
            b3.freestanding[1] = true
            a4(aX.freestanding[1], true)
            a4(aX.freestanding[2], "Always on")
            return
        else
            a4(aX.freestanding[1], false)
            b3.freestanding[1] = true
        end
        if dH == b3.manual_left[1] and dI == b3.manual_right[1] and dJ == b3.manual_reset[1] then
            return
        end
        b3.manual_left[1], b3.manual_right[1], b3.manual_reset[1] = dH, dI, dJ
        if dH and dG == 1 or dI and dG == 2 or dJ and dG == 3 then
            a4(cG, 0)
            return
        end
        if dH and dG ~= 1 then
            a4(cG, 1)
        end
        if dI and dG ~= 2 then
            a4(cG, 2)
        end
        if dJ and dG ~= 3 then
            a4(cG, 3)
        end
    end
    b6.rf_data = {
        pitch = {"Default", 0},
        yaw_base = "Local view",
        yaw = {"180", 0},
        yaw_jitter = {"Off", 0},
        body_yaw = {"Static", 0},
        freestand_yaw = false
    }
    b6.def_data = {cmd_num = 0, checker = 0, tickbase = 0}
    b6.update_cmdnumber = function(da)
        b6.def_data.cmd_num = da.command_number
    end
    b6.update_tickbase = function(da)
        if da.command_number == b6.def_data.cmd_num then
            local dL = K(y(), "m_nTickBase")
            b6.def_data.tickbase = math.abs(dL - b6.def_data.checker)
            b6.def_data.checker = math.max(dL, b6.def_data.checker or 0)
            b6.def_data.cmd_num = 1
        end
    end
    b6.is_defensive_active = function()
        local dM = y()
        if dM == nil then
            return false
        end
        if
            (a9(aX.hide_shots[1]) == false or a9(aX.hide_shots[2]) == false) and
                (a9(aX.doubletap[1]) == false or a9(aX.doubletap[2]) == false)
         then
            return false
        end
        return b6.def_data.tickbase > 2.999681459999995998498010104 and
            b6.def_data.tickbase < 16.02989523959497059475636968798249830139991
    end
    b6.reset_defn = function()
        b6.def_data.defensive = 0
        b6.def_data.checker = 0
    end
    local dN = require("gamesense/csgo_weapons")
    b6.do_defensive = function(da)
        local dO = aY.get_sIndex(y(), b3.builder)
        if a9(b3.builder[dO].defen_option[1]) ~= "off" then
            da.force_defensive = true
        end
        local dP = true
        if J(y()) ~= nil and dN(J(y())).type == "knife" then
            dP = false
        end
        if b6.is_defensive_active() and dP then
            return true
        end
    end
    g("run_command", b6.update_cmdnumber)
    g("predict_command", b6.update_tickbase)
    g("level_init", b6.reset_defn)
    b6.run_paint = function()
        if y() == nil then
            return
        end
        local dO = aY.get_sIndex(y(), b3.builder)
        d6 = d7(a9(b3.builder[dO].fake_yaw_limit))
    end
    b6.setup_anti = function(da)
        local dQ = a9(b3.a_enable)
        local d9 = b6.rf_data
        b6.update_manual()
        local dR = a9(cG)
        local dS =
            ({
            [1] = b0.table_contain(a9(b3.manual_options), "f. straight") and -90 or -70,
            [2] = b0.table_contain(a9(b3.manual_options), "f. straight°") and 90 or 110
        })[dR]
        local dO = aY.get_sIndex(y(), b3.builder)
        if dQ then
            if a9(b3.legit_aa) then
                aY.on_use(da)
                d9.pitch[1] = "Off"
                d9.yaw[1] = "Off"
                d9.yaw_jitter[1] = "Off"
                d9.body_yaw[1] = "Static"
                d9.body_yaw[2] = -180
                d9.freestand_yaw = true
            else
                local c5 = entity.get_player_weapon(y())
                if entity.get_classname(c5) == "CKnife" and (dO == 6 or dO == 5) then
                    d9.pitch[1] = "Minimal"
                    d9.yaw[1] = "180"
                    d9.yaw[2] = 8
                    d9.yaw_jitter[1] = "Off"
                    d9.body_yaw[1] = "Static"
                    d9.body_yaw[2] = 0
                    d9.freestand_yaw = false
                else
                    local dT = b6.do_defensive(da)
                    d9.pitch[1] =
                        a9(b3.builder[dO].defen_option[1]) ~= "off" and dT and a9(b3.builder[dO].pitch_defn[1]) or
                        a9(b3.builder[dO].pitch[1])
                    d9.pitch[2] =
                        a9(b3.builder[dO].defen_option[1]) ~= "off" and dT and a9(b3.builder[dO].pitch_defn[2]) or
                        a9(b3.builder[dO].pitch[2])
                    d9.yaw[1] =
                        a9(b3.builder[dO].defen_option[1]) ~= "off" and dT and a9(b3.builder[dO].yaw_defn[1]) or
                        a9(b3.builder[dO].yaw[1])
                    d9.yaw_jitter[1] = a9(b3.builder[dO].yaw_jitter[1])
                    d9.yaw[2] =
                        a9(b3.builder[dO].defen_option[1]) ~= "off" and dT and
                        (a9(b3.builder[dO].yaw_defn[2]) == "off" and a9(b3.builder[dO].yaw_defn[3]) or
                            a9(b3.builder[dO].yaw_defn[2]) == "traditional" and
                                aY.tr_jitter(
                                    a9(b3.builder[dO].yaw_defn[4]),
                                    a9(b3.builder[dO].yaw_defn[5]),
                                    a9(b3.builder[dO].fake_yaw_limit)
                                ) or
                            a9(b3.builder[dO].yaw_defn[2]) == "extend jitter" and
                                aY.ex_jitter(20, -20, a9(b3.builder[dO].yaw_defn[6]), a9(b3.builder[dO].fake_yaw_limit))) or
                        (a9(b3.builder[dO].yaw[2]) == "off" and a9(b3.builder[dO].yaw[3]) or
                            a9(b3.builder[dO].yaw[2]) == "traditional" and
                                aY.tr_jitter(
                                    a9(b3.builder[dO].yaw[4]),
                                    a9(b3.builder[dO].yaw[5]),
                                    a9(b3.builder[dO].fake_yaw_limit)
                                ) or
                            a9(b3.builder[dO].yaw[2]) == "extend jitter" and
                                aY.ex_jitter(20, -20, a9(b3.builder[dO].yaw[6], a9(b3.builder[dO].fake_yaw_limit))))
                    d9.yaw_jitter[2] =
                        a9(b3.builder[dO].yaw_jitter[2]) == "off" and a9(b3.builder[dO].yaw_jitter[3]) or
                        a9(b3.builder[dO].yaw_jitter[2]) == "traditional" and
                            aY.tr_jitter(
                                a9(b3.builder[dO].yaw_jitter[4]),
                                a9(b3.builder[dO].yaw_jitter[5], a9(b3.builder[dO].fake_yaw_limit))
                            ) or
                        a9(b3.builder[dO].yaw_jitter[2]) == "extend jitter" and
                            aY.ex_jitter(10, -10, a9(b3.builder[dO].yaw_jitter[6], a9(b3.builder[dO].fake_yaw_limit)))
                    d9.body_yaw[1] = a9(b3.builder[dO].body_yaw[1])
                    d9.body_yaw[2] =
                        a9(b3.builder[dO].body_yaw[2]) == "off" and a9(b3.builder[dO].body_yaw[3]) or
                        a9(b3.builder[dO].body_yaw[2]) == "traditional" and
                            aY.tr_jitter(
                                a9(b3.builder[dO].body_yaw[4]),
                                a9(b3.builder[dO].body_yaw[5], a9(b3.builder[dO].fake_yaw_limit))
                            ) or
                        a9(b3.builder[dO].body_yaw[2]) == "extend" and
                            aY.ex_jitter(60, -60, a9(b3.builder[dO].body_yaw[6], a9(b3.builder[dO].fake_yaw_limit))) or
                        a9(b3.builder[dO].body_yaw[2]) == "adaptive" and
                            aY.ex_jitter(1, -1, a9(b3.builder[dO].body_yaw[7], a9(b3.builder[dO].fake_yaw_limit)))
                    d9.freestand_yaw = false
                end
            end
            b6.rf_data.yaw_base = (dR == 0 or dR == 3 and not a9(b3.legit_aa)) and "At targets" or "Local view"
            b6.rf_data.yaw[2] = (dR == 0 or dR == 3) and b6.rf_data.yaw[2] or dS
            b6.rf_data.yaw_jitter[1] =
                b0.table_contain(a9(b3.manual_options), "f. static") and dR ~= 0 and "Off" or b6.rf_data.yaw_jitter[1]
            b6.rf_data.body_yaw[1] =
                b0.table_contain(a9(b3.manual_options), "f. static") and dR ~= 0 and "Off" or b6.rf_data.body_yaw[1]
        elseif dQ == false then
            d9.pitch[1] = "Minimal"
            d9.pitch[2] = 0
            d9.yaw_base = "Local view"
            d9.yaw[1] = "180"
            d9.yaw[2] = 0
            d9.yaw_jitter[1] = "Center"
            d9.yaw_jitter[2] = 0
            d9.body_yaw[1] = "Static"
            d9.body_yaw[2] = 0
        end
        a4(aX.enabled, a9(b3.a_enable))
        a4(aX.pitch[1], d9.pitch[1])
        a4(aX.pitch[2], d9.pitch[2])
        a4(aX.yaw_base, d9.yaw_base)
        a4(aX.yaw[1], d9.yaw[1])
        a4(aX.yaw[2], d9.yaw[2])
        a4(aX.yaw_jitter[1], d9.yaw_jitter[1])
        a4(aX.yaw_jitter[2], d9.yaw_jitter[2])
        a4(aX.body_yaw[1], d9.body_yaw[1])
        a4(aX.body_yaw[2], d9.body_yaw[2])
        a4(aX.freestanding_body_yaw, d9.freestand_yaw)
        local cx = function(cy)
            a0(aX.enabled, cy)
            a0(aX.pitch[1], cy)
            a0(aX.pitch[2], cy)
            a0(aX.yaw_base, cy)
            a0(aX.yaw[1], cy)
            a0(aX.yaw[2], cy)
            a0(aX.yaw_jitter[1], cy)
            a0(aX.yaw_jitter[2], cy)
            a0(aX.body_yaw[1], cy)
            a0(aX.body_yaw[2], cy)
            a0(aX.freestanding_body_yaw, cy)
            a0(aX.edge_yaw, cy)
            a0(aX.freestanding[1], cy)
            a0(aX.freestanding[2], cy)
            a0(aX.roll, cy)
        end
        cx(not a9(b3.a_enable))
    end
    local dU = function(dV, dW, dX)
        dX = dX or 3
        return dV + (dW - dV) * V() * dX
    end
    aW.new = function(bp, dY, dZ, d_, dX)
        if d_ ~= nil then
            if d_ then
                return dU(bp, dY, dX)
            else
                return dU(bp, dZ, dX)
            end
        else
            return dU(bp, dY, dX)
        end
    end
    aW.new_color = function(aZ, e0, e1, d_, dX)
        if d_ ~= nil then
            if d_ then
                aZ.r = dU(aZ.r, e0.r, dX)
                aZ.g = dU(aZ.g, e0.g, dX)
                aZ.b = dU(aZ.b, e0.b, dX)
                aZ.a = dU(aZ.a, e0.a, dX)
            else
                aZ.r = dU(aZ.r, e1.r, dX)
                aZ.g = dU(aZ.g, e1.g, dX)
                aZ.b = dU(aZ.b, e1.b, dX)
                aZ.a = dU(aZ.a, e1.a, dX)
            end
        else
            aZ.r = dU(aZ.r, e0.r, dX)
            aZ.g = dU(aZ.g, e0.g, dX)
            aZ.b = dU(aZ.b, e0.b, dX)
            aZ.a = dU(aZ.a, e0.a, dX)
        end
        return {r = aZ.r, g = aZ.g, b = aZ.b, a = aZ.a}
    end
    aW.counter = function(e2, e3, e4)
        return 100 / (e2 / (e3 + e4 - globals.realtime())) <= 0 and 0 or 100 / (e2 / (e3 + e4 - globals.realtime()))
    end
    b1.c_alpha = 0
    b1.c_scoped = 0
    b1.c_scopedA = 0
    b1.pixel_rectangle = function(cU, cV, e2, cp, e5, bF, cl, d9, e6, e7)
        ab(cU - 1, cV - 1, e2 + 2, cp + 2, 25, 25, 25, d9)
        ab(cU, cV, e2, cp, e5, bF, cl, d9)
    end
    b1.blur_outlined_rect = function(cU, cV, e2, cp, e5, bF, cl, d9, e8, e9, ea, eb)
        ab(cU - 1, cV - 1, e2 + 2, cp + 2, 0, 0, 0, d9 / 2)
        renderer.blur(cU, cV, e2 * e8, cp * e8)
        if e9 >= e2 - e2 / 10 then
            e9 = e2 - e2 / 10
        end
        if eb >= e2 - e2 / 10 then
            eb = e2 - e2 / 10
        end
        ab(cU + e2 / 10 / 2 - 1, cV + ea - 1, e2 - e2 / 10 + 2, 5, 10, 10, 10, d9)
        ab(cU + e2 / 10 / 2, cV + ea, e9, 3, e5, bF, cl, d9)
        ab(cU + e2 / 10 / 2, cV + ea, eb, 3, e5, bF, cl, d9 / 2)
    end
    b1.limited_rectangle = function(cU, cV, e2, cp, e9, e5, bF, cl, d9, dT)
        ab(cU, cV, e2, cp, e5, bF, cl, d9)
        ab(cU - 1, cV - 1, e9 + 2, cp + 2, 25, 25, 25, d9 / 2)
        af(cU - 1 + e9 + 2, cV - 3, cU - 1 + e9 + 2, cV - 3 + cp + 5, 1, 1, 1, d9)
        af(cU - 1, cV - 3, cU - 1, cV - 3 + cp + 5, 1, 1, 1, d9)
        af(cU - 1, cV - 2, cU - 1 + e9 + 2, cV - 2, 1, 1, 1, d9)
        af(cU - 1, cV + cp + 1, cU - 1 + e9 + 2, cV + cp + 1, 0, 0, 0, d9)
        local ec = e9 / dT
        for bt = 1, dT - 1, 1 do
            local ed = cU + bt * ec
            ab(ed, cV, 1, cp, 25, 25, 25, d9 / 2)
        end
    end
    b1.distance = 0
    local ee = 50
    b1.center = function()
        local ef, eg = h()
        local eh, ei = ef / 2, eg / 2
        local ej, ek = ag("-", "MYTH LUA")
        local el, em = ag("-", "MYTH")
        local e5, bF, cl, d9 = a9(b3.center_color)
        local ck = function(cl, cm, cn, co)
            local bE, bF, cp
            local bt = aq(cl * 6)
            local cq = cl * 6 - bt
            local bA = cn * (1 - cm)
            local bB = cn * (1 - cq * cm)
            local b3 = cn * (1 - (1 - cq) * cm)
            bt = bt % 6
            if bt == 0 then
                bE, bF, cp = cn, b3, bA
            elseif bt == 1 then
                bE, bF, cp = bB, cn, bA
            elseif bt == 2 then
                bE, bF, cp = bA, cn, b3
            elseif bt == 3 then
                bE, bF, cp = bA, bB, cn
            elseif bt == 4 then
                bE, bF, cp = b3, bA, cn
            elseif bt == 5 then
                bE, bF, cp = cn, bA, bB
            end
            return bE * 255, bF * 255, cp * 255, co * 255
        end
        local cr = a9(b3.noti_time) / 10
        local bk = N() % cr / cr
        local cs = 1 - math.abs(bk * 2 - 1)
        local ct, cu, cv = ck(cs, 1, 1, 1)
        if a9(b3.noti_rgb) then
            a4(b3.center_color, ct, cu, cv, 255)
        end
        if y() == nil then
            return
        end
        b1.c_alpha = aW.new(b1.c_alpha, 1, 0, b0.table_contain(a9(b3.indicator), "center"), 6)
        b1.c_scopedA = aW.new(b1.c_scopedA, 0, 1, a_.is_scoped(y()), 8)
        b1.c_scoped = aW.new(b1.c_scoped, 1, 0, b1.c_scopedA <= 0.2, 6)
        local en =
            aZ.fade_text(
            e5,
            bF,
            cl,
            d9 * b1.c_scopedA * b1.c_alpha,
            186,
            198,
            212,
            255 * b1.c_scopedA * b1.c_alpha,
            "MYTH"
        )
        ae(eh - (ej / 2 + 5), ei + 10 + 1, 25, 25, 25, 180 * b1.c_scopedA * b1.c_alpha, "-", nil, "MYTH")
        ae(eh - (ej / 2 + 5), ei + 10, 255, 255, 255, 255 * b1.c_scopedA * b1.c_alpha, "-", nil, en)
        b1.pixel_rectangle(
            eh - (ej / 2 + 11) * b1.c_alpha + 1 + aq(17 * b1.c_scoped) + 1 + 1,
            ei + 10 + 1 + 1,
            2,
            9,
            25,
            25,
            25,
            180 * b1.c_scopedA * b1.c_alpha
        )
        b1.pixel_rectangle(
            eh - (ej / 2 + 11) * b1.c_alpha + 1 + aq(17 * b1.c_scoped) + 1,
            ei + 10 + 1,
            2,
            9,
            125,
            125,
            125,
            255 * b1.c_scopedA * b1.c_alpha
        )
        local eo = L(true)
        local cR, cS, cT = K(y(), "m_vecOrigin")
        for bt = 1, #eo do
            local cU, cV, cW = K(eo[bt], "m_vecOrigin")
            local df = cK(cR, cS, cT, cU, cV, cW)
            if df > ee then
                ee = df
            end
            local ep = df / ee * 50
            b1.distance = aW.new(b1.distance, ep, 6)
        end
        local eq = 50
        b1.limited_rectangle(eh - eq / 2, ei + 25, b1.distance, 5, eq, e5, bF, cl, d9 * b1.c_scoped * b1.c_alpha, 6)
        ae(
            eh - eq / 2 - 1,
            ei + 31,
            205,
            205,
            205,
            180 * b1.c_scoped * b1.c_alpha,
            "-",
            nil,
            aR(D(client.current_threat()))
        )
        ae(
            eh - (ej / 2 + 5) + el + 2 + 2,
            ei + 10 + 1,
            25,
            25,
            25,
            180 * b1.c_scopedA * b1.c_alpha,
            "-",
            ej * b1.c_scopedA * b1.c_alpha,
            "LUA."
        )
        ae(
            eh - (ej / 2 + 5) + el + 2,
            ei + 10,
            90,
            90,
            90,
            255 * b1.c_scopedA * b1.c_alpha,
            "-",
            ej * b1.c_scopedA * b1.c_alpha,
            "LUA."
        )
    end
    b1.ox = 0
    b1.oy = 0
    b1.dragging = false
    b1.run_dragging = function()
        local er = client.key_state(0x01)
        local es, et = ui.mouse_position()
        local cU, cV = a9(b3.pos_x), a9(b3.pos_y)
        local ef, eg = h()
        if b1.dragging then
            local ed, eu = cU - b1.ox, cV - b1.oy
            a4(b3.pos_x, ay(ao(es + ed, 0), ef))
            a4(b3.pos_y, ay(ao(et + eu, 0), eg))
            b1.ox, b1.oy = es, et
        else
            b1.ox, b1.oy = es, et
        end
    end
    b1.is_dragging = function(cU, cV, e2, cp)
        local es, et = ui.mouse_position()
        local er = client.key_state(0x01)
        local ev = es > cU and es < cU + e2
        local ew = et > cV and et < cV + cp
        return ev and ew and er and _()
    end
    b1.is_dragging_menu = function()
        local cU, cV = ui.mouse_position()
        local ds, dt = ui.menu_position()
        local ef, eg = ui.menu_size()
        local er = client.key_state(0x01)
        local ev = cU > ds and cU < ds + ef
        local ew = cV > dt and cV < dt + eg
        return ev and ew and er and _()
    end
    b1.t_alpha = 0
    b1.t_rect = 0
    b1.arrows = {
        g_alpha = 0,
        ["left"] = {r = 0, g = 0, b = 0, a = 0},
        ["right"] = {r = 0, g = 0, b = 0, a = 0},
        ["animate"] = {right_x = 0, left_x = 0},
        menu_alpha = 0
    }
    b1.arrows_render = function()
        local ex = b1.arrows
        local ef, eg = h()
        local es, et = ef / 2, eg / 2
        local ey = es / 210 * a9(b3.arrow_distance)
        ex.g_alpha = aW.new(ex.g_alpha, 1, 0, b0.table_contain(a9(b3.indicator), "manual indicator"), 6)
        if y() == nil then
            return
        end
        if ex.g_alpha < 0.01 then
            return
        end
        local ez =
            '<svg t="1686019116149" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1930" width="200" height="200"><path d="M262.144 405.504l255.68-170.432a128 128 0 0 1 198.976 106.496v340.864a128 128 0 0 1-199.008 106.496l-255.648-170.432a128 128 0 0 1 0-212.992z" p-id="1931" fill="#ffffff"></path></svg>'
        local eA =
            '<svg t="1686019127483" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2144" width="200" height="200"><path d="M761.856 405.504l-255.68-170.432A128 128 0 0 0 307.2 341.568v340.864a128 128 0 0 0 199.008 106.496l255.648-170.432a128 128 0 0 0 0-212.992z" p-id="2145" fill="#ffffff"></path></svg>'
        local eB = renderer.load_svg(ez, 32, 32)
        local eC = renderer.load_svg(eA, 32, 32)
        local dR = a9(cG)
        local bG, bH, bI, bJ = ui.get(b3.arrow_color)
        local ck = function(cl, cm, cn, co)
            local bE, bF, cp
            local bt = aq(cl * 6)
            local cq = cl * 6 - bt
            local bA = cn * (1 - cm)
            local bB = cn * (1 - cq * cm)
            local b3 = cn * (1 - (1 - cq) * cm)
            bt = bt % 6
            if bt == 0 then
                bE, bF, cp = cn, b3, bA
            elseif bt == 1 then
                bE, bF, cp = bB, cn, bA
            elseif bt == 2 then
                bE, bF, cp = bA, cn, b3
            elseif bt == 3 then
                bE, bF, cp = bA, bB, cn
            elseif bt == 4 then
                bE, bF, cp = b3, bA, cn
            elseif bt == 5 then
                bE, bF, cp = cn, bA, bB
            end
            return bE * 255, bF * 255, cp * 255, co * 255
        end
        local cr = a9(b3.noti_time) / 10
        local bk = N() % cr / cr
        local cs = 1 - math.abs(bk * 2 - 1)
        local ct, cu, cv = ck(cs, 1, 1, 1)
        if a9(b3.noti_rgb) then
            a4(b3.arrow_color, ct, cu, cv, 255)
        end
        ex["left"] =
            aW.new_color(
            ex["left"],
            {r = bG, g = bH, b = bI, a = bJ * ex.g_alpha},
            {r = 0, g = 0, b = 0, a = 0},
            dR == 1 or _(),
            6
        )
        ex["right"] =
            aW.new_color(
            ex["right"],
            {r = bG, g = bH, b = bI, a = bJ * ex.g_alpha},
            {r = 0, g = 0, b = 0, a = 0},
            dR == 2 or _(),
            6
        )
        local eD = es - 34 + ey
        local eE = es - ey
        ex["animate"].right_x = aW.new(ex["animate"].right_x, eD, 6)
        ex["animate"].left_x = aW.new(ex["animate"].left_x, eE, 6)
        local eF = aq(ex["animate"].right_x)
        local eG = aq(ex["animate"].left_x)
        renderer.texture(eB, eG + 1, et + 1 + 1, 32, 31, 25, 25, 25, ex["left"].a, "f")
        renderer.texture(eC, eF + 1, et - 1 + 1, 32, 32, 25, 25, 25, ex["right"].a, "f")
        renderer.texture(eB, eG, et + 1, 32, 31, ex["left"].r, ex["left"].g, ex["left"].b, ex["left"].a, "f")
        renderer.texture(eC, eF, et - 1, 32, 32, ex["right"].r, ex["right"].g, ex["right"].b, ex["right"].a, "f")
    end
    b1.start_time = N()
    b1.check = false
    b1.start_time2 = N()
    b1.check2 = false
    b1.alpha = 0
    b1.text_alpha = 0
    b1.menu_alpha = 0
    local eH =
        [[iVBORw0KGgoAAAANSUhEUgAABUIAAADdCAYAAAB+Mwg8AAAYlElEQVR42u3dXahe2VkH8GeVUETKYCGt02hbFVpmRtuLNAPVC6kXIqO1RYrnKBbrTRFEhHohrVoGy4hKEUUtXniliBYVqUMpQyk1HSotjhaR2nw4PcahZuIQhiGEEkLI8iLvxJM0OfN+7I+19vP7wWFCcs67z7v2ft/h/M9/7ScCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgEUp635irbVarp28oZRyaY4D11ofjIjnnYIdXiillAHOwz9GxLsSL+PDpZSzM70GHoqIM4nX/nQp5Ue2XDvv/cz93lmt4Xys/7zrj+vV9eq6c91Z/yW/7mUVXZgtyxrLq5zTyZyc8dinLH8THk/+/PeSHtu1BwAA8K1kFe07ubQnJAjN8QI/afnnV0p5OiJOJ16C/aTHntvp1bUHAADQEllF+xYXVgtCp/OOGY/9qOVvRuZm3iOrLeqTWh3zEdccAABAU2QV7XvH0p6QIHQ6GqFohc6zRT3ztnhtUAAAoFWyivZphLK1E6sbAU9qdcwTlr8pmRt6+0mO6VoDAAC4D1lFN2bJssYkCJ3WHL/tcPPhxiRvhU66PT75tnhtUAAAoFWyin4sqrkrCF3+C13VvE2Zm3p7Cz2WawwAAGA9sop+LCq0FoROa46bzLr5cIOSt0L3F3qslmiDAgAALZNV9GNRA5MEodPSCOWwrI29SbbHJ98Wrw0KAAC0TFbRD41QtjbpTWbdfLhtyVuhews5Rou0QQEAgGbJKrqzqIFJgtDpTflbDzcfbl/W5t7+Qo7hmgIAANiMrKI/i2nwCkKX/YJXNW9c4lboqNvjE2+L1wYFAABaJ6voz2LCa0Ho9Ka8yaybD/cha4Nvr9PHdi0BAABsT1bRn8UMTBKETk8jlDskboXud/rYrdIGBQAAeiCr6I9GKFub5Cazbj7cnYxNvlG2xyfeFq8NCgAANE1W0a3FDEwShM5jit9+uPlwRxK3Qvc6eczWaYMCAAA9kFX0axFNXkHocl/4qub9ydjo2+/kMV07AAAAu5NV9GsRIbYgdB5T3GTWzYc7k7QVOuj2+KTb4rVBAQCAXsgq+rWIgUmC0HlohHI/GZt9e40+lmsGAABgWLKKfmmEsrVRbzLr5sP9StoK3W/0sXqgDQoAAHRBVtG9RQxMEoTOZ8zfgrj5cN+yNfwG2R6fdFu8NigAANALWUX/um/0CkKX+Qagat6xpK3QvUYeoyfaoAAAQE9kFf3rPswWhM5nzJvMuvlw/7I1/fYbeQzXCAAAwDhkFf3rfmCSIHQ+GqHcV8JW6E7b4xNui9cGBQAAeiOr6J9GKFsb5Sazbj68KNkaf3szfa1rAwAAYESyisXofmCSIHReY/w2xM2HFyJhK3R/pq/tjTYoAADQG1nFcnTd7BWELu+NQNV8WTI1/7baHp9wW7w2KAAA0JsMWcU3IuJigufZdagtCJ3XGDeZdfPhBUnYCt2b6Gt6pQ0KAAD0KENWcX71sXRdD0wShM5LI5R1ZGoA7k/0Na4FAACA6WTIKrIEoRqhbG3Qm8y6+fAyJWuFbrQ9Ptm2eG1QAACgO4myinMRcSbB8+x6YJIgdH5D/lbEzYeXK1MTcG+kz3UNAAAATC9LVpGlERrRccP3mNdjE28In8l+IXK0UsrTtdbTEfGuBE93PyI+tsHnZjBbG7SUUlpemFprTf7eUAIAANqWJas4n+icDpllTUojdH5D3mTWoKRly9IIXGt7fLJt8dqgAABArzJkFdcj4mD1cT3B8+12YJIgdH5DVsQ1Qhcs2b1C9wb6nCVwb1AAAKBnGbKKg1LKzVLKzYi4kOD5dnu7A0Ho/Aa5yaxBSWlkaQbuD/Q5zjkAAMBMEmUVh7fFn03wfLsdmCQIbcMQvx0xKCmBRK3QI7fHJ9oWrw0KAAD0LNOgpHv9ecm6bPoKQpfzxmBbfB5ZGoJ7W/6bcw0AANCGLFnFufv8ecm6DLkFoW0Y4iazBiUlkagVur/lvy2FNigAANC7LFnF4e3wWRqhXQ5MEoS2QSOUTWVoCt5ze3yibfHaoAAAQO+yZBUZt8ZrhLK1nW4ya1BSPolaoXtr/t3SaIMCAABdS5RVXCmlvHDo5/VLEXElwfPucmCSILQdu/yWxKCknDI0BvfX/DvnFgAAoC0ZByUd9XdL1F3jVxC6jDcI2+ITStIKvWN7fJJt8dqgAADAEmTcFn/U3y1Rd2G3ILQdu9xk1qCkvDI0B/fu82fnFAAAoF1Zsopza/7dEnU3MEkQ2g6NUDaWpBW6f58/L5E2KAAAsBRZsoqz9/g7jdBGCULbsdVNZg1KIpbfIHyk1vpQkm3x2qAAAED3kmUVmbfGdzcwSRDalm1+W2JQUnJJWqF7sfxt8dqgAADAUmTKKjIHoRGdNX8Fof2/UdgWT8Tym4T7sfxt8dqgAADAUmTJKi6WUr5591+WUq5GxMUka9BV6C0Ibcs2N5k1KIkMrdBHYtnb4rVBAQCAJcmSVZzf8t+WpKuBSYLQtmiEsguNQucOAACgBZkHJb3MwKQGCULbstFNZg1K4rAk9wpdIm1QAABgMZJlFee2/Lcl6WpgkiC0PZv81sSgJO6mWeicAQAAzCn7oKR1/m1pumkAC0L7fsOwLZ47aIV2RxsUAABYmkxZxVFh59lE69BN+C0Ibc8mN5k1KIl70TB0rgAAAOaSJau4HhEHR/z7QUTcSLIW3QxMEoS2RyOUnWiFdkMbFAAAWKIsWcWFUsrNI342vxlHB6VLohHK1ta6yaxBSbwCTUPnCAAAYFLJsop1tr5nuU9oNwOTBKFtWue3JwYlcV9aoc3TBgUAAJbIoKTNP2cpumgCC0L7feOwLZ5XonHo3AAAAEwpU1ZxbqDPWYouQnBBaJvWucmsQUkcSSu0WdqgAADAUmXKKtZpe2aaHN/FwCRBaJs0QhmK5qFzAgAAMJVMWYWt8XfSCGVrR95k1qAk1qUV2hxtUAAAYJGSZRVXSimX1viZ/FJEXE2yJl0MTBKEtuuo36IYlMQmNBCdCwAAgLEZlLT75/au+UawILTPNxDb4lmbVmgztEEBAIAlsy1+98/tXfNhuCC0XUfdZNagJDaliegcAAAAjClTVrHJNPgzidal+YFJx7xOm6URymBKKU/XWk9HxLusxiy0QYGt1FqrVQAAOqERuvvn9k4jlK3d8yazBiWxA41Eaw8AADC4hFmFIPTemh+YJAht271+m2JQEltxr9DZaIMCAABLly2rEITeX9PNYEFof28ktsWzC81Eaw4AADC0TFnFxVLK1XU/efW5lxKtT9OhuCC0bfe6yaxBSWxNK3Ry2qAAAEAGmbKK8xN9Ta+aHpgkCG2bRihj0FC01gAAAEMyKOloZxOtj0YoW7vjJrMGJTEErdDJaIMCAACLlzCrODfR1/Sq6YFJgtD2Hf6tikFJDEVT0RoDAAAMwaCkcb6mZ802hAWhfb2h2BbPILRCR6cNCgAAZJEtq9hmm3u2ILTZcFwQ2r7DN5k1KIkhaSxaWwAAgF1lyipuRMTBFl93sPraLJodmCQIbZ9GKKPQCh2NNigAAJBJpqzioJRyc4ufv29ExIVE66QRytZO1FofNCiJkWguWlMAAICtJMwqdtninmlyfLMDkwShfTgZBiUxAq3QwWmDAgAAmRiUNM3X9qjJprAgtJ83FtviGYsGo7UEAADYRras4swOX3su2Vo1GZILQvvwjjAoiZFohQ5GGxQAAMgmW1ahEbq+JgcmCUL7oBHK2DQZrSEAAMCmsmUVgtD1aYR27uKMxz4R8958+KLTv2xaoTvTBgUAAFJJOCjpainl0g4/d1+MiKuJ1qvJgUmC0PV9JfFz/xenPwWNRmsHAACwLoOS5nmMnjTXGBaEru+ZxM/9X53+5dMK3Zo2KAAAkJFt8fM8Rk+aC8sFoevTCCUDzUZrBgAAsI5sg5LODPAYBibNTBC6vsxh4Fec/hy0QjemDQoAAGSlEbq5c8nWTCO0V6sb4mYcGnRxl5sB0yUNR2sFAABwXwkHJUXYGr+N5gYmCUI3k7EZaVt8Mlqha9MGBQAAsjqV8DkPEWKeTbhuTTWHBaGbyTgwyaCknDQdrREAAMD9ZNsWf6mUcnXXB1k9RrZdt02F5oLQzWiEkoJW6CvSBgUAADLLNijpfKOP1YOmBiYJQjeTMRQ0KCkvjUdrAwAAcC/ZGqFDbmnPFoRqhPYq4cAkg5JyX+9aofemDQoAAKSVdFDSuUYfqwdNDUwShG4uU0PStng0H60JAADAYQYl7cbApBkJQjeXaWCSQUnJaYV+C21QAAAgu5MJn7N7hO6mmfBcELo5jVCy0YC0FgAAAC/LNijpRkQcDPh4B6vHzKSZgUmC0M1lCgcNSkIr9P9pgwIAAORrhB6UUgYLLlePdSHZGmqE9irRwCSDkjhME9IaAAAAySUdlHS+k8dsWTMDkwSh28nQlLQtnts0Ia0BMNt7z6ycAQDgLgYltfuYrWuiSSwI3U6GgUkGJQEAAACHZRyUdG6ExzyTcB2bCNEFodvRCAUAAACyeTThc9YIHUYTA5MEodvJEBIalAQAAAAclrERKggdhkZorxIMTDIoCQAAALgt6aCkq6WUwfOf1WNeTbaWTQxMEoRub8mNSdviAQAAgMMMShrWswnXc/ZGsSB0e0semGRQEgAAAHCYbfH9PHarZg/TBaHb0wgFAAAAsjAoaVhnE67n7AOTBKHbW3JYaFASAAAAcFjGRui5Th+7VRqhvVrwwCSDkgAAAIDbkg5Kihi3tZlxa/zsA5MEobtZYnPStngAAADgsFNJn7d7hA5v1maxIHQ3SxyYZFASAAAAcFjGbfGXSilXx3rwUsqViHgh4brOGqoLQnejEQoAAAAsnUFJ4zAwaWKC0N0sMTQ0KAkAAAA4LGMj9PxCjtEajdBeLXBgkkFJAAAAwG2JByWdW8gxWjPrwCRB6O6W1KC0LR4AAAA4LOugpCm2rRuYNLFjXs87eyYi3r2Q52JQEgAAwPpuRuKCUa31WCnlxlzHTn7tTbnuJ5Ou8cdrrY+PfIzXJF3bUxHxmTkOLAjdnUYoAABATtcj4tsSP//XRMRLMx37geTX3pRB6KNJ1/ghb3GjmW1gkq3xu1tSeGhQEgAAwPquJ3/+r5/x2A+69iZz0kudgc12uwVB6I4WNDDJoCQAAIDNZA9C3zrjsR9y7Y0v8aAkxjXbwCRB6DCW0KS0LR4AAGAzV5M//zmbgo+69iZxysucJb1/CEKH8cwCnoNBSQAAAJt5Kfnz/9EZj/3jydf+xYmOY1s8Y5klZBeEDkMjFAAAIJ/LyZ//O2ut3z31QWutb4+It7v2JvGolzkjmWVgkiB0GEsIEQ1KAgAA2MyLyZ//sYj4xRmO+yGXnkYo3dMI7dUCBiYZlAQAALDFz1KWIH6l1np8qoPVWh+JiPdb9vGvPYOSGNksA5MEocPpuVFpWzwAAMDm/ssSxAMR8QcTHu9P41YT1bU3PoOSGNvkjWNB6HB6HphkUBIAAMDmLliCiIh4f631F8Y+SK31NyPihy13REQcTHAM2+IZ2+RhuyB0OBqhAAAAuRxYgtv+rNb6M2M9eK315yPityzzpNeeQUmMbfKBSYLQ4fQcJhqUBAAAsLmzEXHdMkTEre3qf11r/USt9YGhHrTW+upa6+9ExJ+HDONl1yLi/ATH0QhlbBqhvep4YJJBSQAAANv9HHgjIr5mJe7wSxHx9VrrL9dad7qXZ631PRFxJiI+bFnv8LVSys0xD2BQEhOZfGCSIHRYPTYrbYsHAADI9XPg2I5HxB9HxH/XWn99k6nytdbjtdZfrbWei4h/iIjvs5zf4t8mOIZBSUxl0uaxIHRYPQ5MMigJAABge1+yBPd1IiJ+OyKer7V+odb6a7XW99Ra315rfaDW+qpV8PlDtdYP11q/EBHPR8TvR8RbLd99/dMEx7AtnqlMGrofs96D0ggFAOCeaq215++/lFKcRdfXUu14fZ+2gq/oWNya9m7i+zCmuOYMSmIqkw5M0ggdVo+hom0cAAAAWyqlPBsR37ASTOS5UsoUE+M1QpnKpI1QQeiw/wPsbWCSQUkAAAC7+6wlYCJPjX0Ag5KY2KQDkwShw+upYWlbPAAAwO7+1hKwoGvNoCSmNlkDWRA6vJ4GJhmUBAAAsLvPRcSLloGRXY6Iz09wHNvimdpk4bsgdHgaoQAAAImUUm5ExN9ZCUb2N6WUmxMcx6AkpjbZwCRB6PB6ChcNSgIAABjGJywBC7nGNEKZmkZorzoamGRQEgAAwHA/C/57RHzRSjCS06WUr419EIOSmMlkA5MEoePooWlpWzwAAMCwPm4JGMnvTXQcg5KYyyRNZEHoOHoYmGRQEgAAwIBKKU9GxD9bCQb2xVLKUxMdy7Z45jJJCC8IHYdGKAAAQE4fsQQM7DcmPJZBScxlkoFJgtBx9BAyGpQEAAAwsFLK5yPik1aCgfxlKeXpCY+nEcpcJmmElnU/sdZak//PrGzy+bXW/4l2bzB8sZTyXRs+H+c/OdeAa8B16bp0jvOdY+s/7Pr3vp6tv+dkv15p7vV+PCLORMRxq8sOXoiIh0spL070PvpgRDxv2ZnRG8Ye7K0ROp6WG5e2xQMAAIyklHI5Ij5oJdjBzYj44FQh6IpBScxt9EayIHQ8LQ9MMigJAABgRKWUT0XE71oJtvTEavjWlGyLZ26jh/GC0PFohAIAACRWSvlIRHzaSrChJ0spj89wXIOSmNvoA5MEoeNpOWw0KAkAAGAa74uIz1kG1vTZiPjpmY6duRH65tKIiNhPfB40Qnu1urnrxQa/tYtj33gWAACA2z8bXo+In4yI01aDV/D5iHjv6pqZ1GpQ0omk636tlPJcQ9/Ps4lfAydW1+JoBKHjarF5aVs8AADAhEop1yLixyLik1aD+/iriHhsda3MIfOgpGd9P00ZtZksCB1XiwOTDEoCAACYWCnleinlZyPiY3FrIjjE6lp4vJTyc3M0QQ/JvC3+bGPvFVci4sXE52PUUF4QOi6NUAAAAG5bDcF5LCLcsoxLcasF+rEGvpfMg5LON/g9ZW6FjjowSRA6rhZDR4OSAAAAZlRK+WxEvC0inrQaaX0qIt62uhZakLkReq7B7ylzEKoR2vH/3FobmGRQEgAAQBs/L14upbw3It4bEResSBoX4tZApJ8qpVxu4RtKPigpos1G6EHi8zHqwCRB6PhaamDaFg8AANCQUsqTEfFwRHw0Il6yIov10uocP7w65y05lfzctBiE/mfyczJaQ1kQOr6WBiYZlAQAANCYUsq1UsoTEfG9EfFERFyxKotxJW4NyHpzKeWJGafCHyXztvjLpZQWBxMdJH/djBbOC0LHpxEKAADAKyqlvFRK+WhEvDEiPhS57xPYu2dX5/CNpZTHV5PAW2VQUpvXT2ajDUwShI6vpfDRoCQAAIDGlVKulFL+sJTylrg1Yf7vI+KalWnetdW5eqyU8pbVOeyh3Zu5EXq+0feASxHxzcTnRSO04/+BtTIwyaAkAACA/n6mfKqU8r6IeF1EfCAingqhaEuurc7JByLidaWU95VSnurlmzcoKc40/L0ZmDQCQeg0Wmhi2hYPAADQqVLK1VLKX5RSHouI10bET0TEn0S7W3uX7GxE/NHqHLy2lPLY6txc7fC5GJTUruzb40dpKh/z/jWJZyLi3TN/DwYlAQAALMBq4M5nVh9Raz0eEe+MiB9c/fdkRHyHlRrES3Gr3PTliPhSRHy5lHJ5Qc/vZPLzKwht16mX3+OGJAidhkYoAAAAo1gFc59efURERK31REQ8EhE/EBHfHxHfs/p4U0S82qrd4XpEPBcRF1Yf/xERX42Irya4xVzmQUk3o+2w8evJX5ejDEwShE6jhRDSoCQAAIAkSikX49a8is/d/W+rkPRNEfH6iDi++u93rv78QES85q6Pb49b+cHhj1fF/Lfbu7n6uHHXxzcj4updH1ci4nJE/G9EvLD686WI+MZqrbLK3Ah9rpRyveHvTyMUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOjW/wErBcLIuS8KCwAAAABJRU5ErkJggg==]]
    local eI = renderer.load_png(b7.decode(eH), 800, 150)
    b1.on_load = function()
        local bz = b1
        bz.alpha = aW.new(bz.alpha, 0, 1, bz.check, 6)
        bz.menu_alpha = aW.new(bz.menu_alpha, 1, 0, _(), 6)
        bz.text_alpha = aW.new(bz.text_alpha, 0, 1, bz.check2, 6)
        local eJ = function(cU, cV, e2, cp, e5, bF, cl, d9)
            ac(cU + 30, cV + 2, e2, cp - 4, 15, 15, 15, d9 / 2, 0, 0, 0, 0, true)
            ab(cU, cV, 30, cp, 25, 25, 25, d9)
            renderer.triangle(cU, cV, cU, cV + cp, cU - 10, cV + cp, 25, 25, 25, d9)
            renderer.triangle(cU + 30, cV, cU + 30, cV + cp, cU + 30 + 10, cV, 25, 25, 25, d9)
            ac(cU - 1, cV - 2, 41, 2, cl, bF, e5, d9, e5, bF, cl, d9, true)
            af(cU, cV - 2, cU - 10, cV - 2 + cp + 1, cl, bF, e5, d9)
            af(cU - 1, cV - 2, cU - 1 - 10, cV - 2 + cp + 1, cl, bF, e5, d9)
            af(cU - 2, cV - 2, cU - 2 - 10, cV - 2 + cp + 1, cl, bF, e5, d9)
            af(cU + 41, cV - 1, cU + 41 - 10, cV - 1 + cp, 10, 10, 10, d9)
            local eK = renderer.load_svg(ba, 23, 23)
            renderer.texture(eK, cU + 4, cV - 1, 23, 23, e5, bF, cl, d9, "f")
        end
        local es, et = ui.menu_position()
        local e5, bF, cl, d9 = a9(b3.noti_color)
        eJ(es + 12, et - 25, 300 * bz.menu_alpha, 20, e5, bF, cl, d9 * bz.menu_alpha)
        local eL =
            aZ.gradient_text(
            e5,
            bF,
            cl,
            d9 * bz.menu_alpha,
            cl,
            bF,
            e5,
            d9 * bz.menu_alpha,
            "Myth Anti-aimbot angles system V1"
        )
        ae(es + 12 + 40 + 1, et - 22 - 1, 0, 0, 0, 255 * bz.menu_alpha, nil, nil, "Myth Anti-aimbot angles system V1")
        ae(es + 12 + 40 - 1, et - 22 + 1, 0, 0, 0, 255 * bz.menu_alpha, nil, nil, "Myth Anti-aimbot angles system V1")
        ae(es + 12 + 40 - 1, et - 22 - 1, 0, 0, 0, 255 * bz.menu_alpha, nil, nil, "Myth Anti-aimbot angles system V1")
        ae(es + 12 + 40 + 2, et - 22 + 2, 0, 0, 0, 255 * bz.menu_alpha, nil, nil, "Myth Anti-aimbot angles system V1")
        ae(es + 12 + 40 + 1, et - 22 + 1, e5, bF, cl, 255 * bz.menu_alpha, nil, nil, eL)
        ae(es + 12 + 40, et - 22, 255, 255, 255, 255 * bz.menu_alpha, nil, nil, "Myth Anti-aimbot angles system V1")
        local ef, eg = h()
        local eK = renderer.load_svg(ba, 300, 300)
        local eM = 10
        local eN = 0.1
        renderer.rectangle(0, 0, ef, eg, 0, 0, 0, 100 * bz.alpha)
        renderer.texture(
            eK,
            ef / 2 - (100 + 2) * bz.alpha,
            eg / 2 - (150 + 2) * bz.alpha - 150 * bz.text_alpha,
            300 * bz.alpha,
            300 * bz.alpha,
            10,
            10,
            10,
            150 * bz.alpha,
            "f"
        )
        renderer.texture(
            eK,
            ef / 2 - 100 * bz.alpha,
            eg / 2 - 150 * bz.alpha - 150 * bz.text_alpha,
            300 * bz.alpha,
            300 * bz.alpha,
            e5,
            bF,
            cl,
            d9 * bz.alpha,
            "f"
        )
        for bt = 1, eM do
            local bD = eN * (eM - bt) / eM
            renderer.texture(
                eI,
                ef / 2 + bt - 350,
                eg / 2 + bt - 75,
                800,
                150,
                e5,
                bF,
                cl,
                bD * 255 * bz.text_alpha,
                "f"
            )
        end
        renderer.texture(eI, ef / 2 - 350, eg / 2 - 75, 800, 150, e5, bF, cl, d9 * bz.text_alpha, "f")
        if bz.start_time2 + 3 < N() then
            bz.start_time2 = N()
            bz.check2 = true
        end
        if bz.start_time + 5 < N() then
            bz.start_time = N()
            bz.check = true
        end
    end
    local eO = function(eh, ei, e2, cp, e5, bF, cl, d9, eP)
        local eQ = {}
        for bt = 0, eP - 1 do
            local d4 = bt / (eP - 1) * math.pi / 2
            local cU = eh - e2 * math.cos(d4)
            local cV = ei - cp * math.sin(d4)
            table.insert(eQ, {x = cU, y = cV})
        end
        for bt = 1, #eQ - 1 do
            local cA = eQ[bt]
            local cB = eQ[bt + 1]
            renderer.line(cA.x, cA.y, cB.x, cB.y, e5, bF, cl, d9)
        end
        local eR = eh - e2
        local eS = ei
        renderer.line(eR, eS, eQ[1].x, eQ[1].y, e5, bF, cl, d9)
        local eT = eh
        local eU = ei - cp
        renderer.line(eT, eU, eQ[#eQ].x, eQ[#eQ].y, e5, bF, cl, d9)
    end
    local eV = function(cU, cV, e2, cp, e5, bF, cl, d9, bN)
        ac(cU + 30, cV + 2, e2, cp - 4, 15, 15, 15, d9 / 2, 0, 0, 0, 0, true)
        ab(cU, cV, 30, cp, 25, 25, 25, d9)
        renderer.triangle(cU, cV, cU, cV + cp, cU - 10, cV + cp, 25, 25, 25, d9)
        renderer.triangle(cU + 30, cV, cU + 30, cV + cp, cU + 30 + 10, cV, 25, 25, 25, d9)
        ac(cU - 1, cV - 2, 41, 2, cl, bF, e5, d9, e5, bF, cl, d9, true)
        af(cU, cV - 2, cU - 10, cV - 2 + cp + 1, cl, bF, e5, d9)
        af(cU - 1, cV - 2, cU - 1 - 10, cV - 2 + cp + 1, cl, bF, e5, d9)
        af(cU - 2, cV - 2, cU - 2 - 10, cV - 2 + cp + 1, cl, bF, e5, d9)
        af(cU + 41, cV - 1, cU + 41 - 10, cV - 1 + cp, 10, 10, 10, d9)
        local eW = 4
        local eX = eW + 2
        local eY = function(cU, cV, e2, cp, eZ, e5, bF, cl, d9)
            renderer.gradient(cU + eZ + eX, cV + 2, e2 - eX * 2 - eZ * 2, 1, cl, bF, e5, d9, e5, bF, cl, d9, true)
            renderer.gradient(cU + eZ + eX, cV + cp - 3, e2 - eX * 2 - eZ * 2, 1, cl, bF, e5, d9, e5, bF, cl, d9, true)
        end
        local e_ = 10
        local f0 = 0.5
        for bt = 5, 1, -1 do
            local bD = d9 / (5 - bt + 1)
            local f1 = (5 - bt) * f0
            eO(cU + 5 - f1, cV + 5 - f1, 8, 6, cl, bF, e5, bD, 50)
        end
        local cL, cM, cO, cP = cU, cV - 1, cU - 10, cV - 1 + cp
        local f2, f3 = cU - 1, cV - 2
        for bt = e_, 1, -1 do
            local bD = d9 / (e_ - bt + 1)
            local f4 = (e_ - bt) * f0
            renderer.gradient(f2, f3 + 2 - f4, 41, 1, cl, bF, e5, bD, e5, bF, cl, bD, true)
        end
        for bt = e_, 1, -1 do
            local bD = d9 / (e_ - bt + 1)
            local f1 = (e_ - bt) * f0
            renderer.line(cL - f1, cM, cO - f1, cP, cl, bF, e5, bD)
        end
    end
    b1.icon_color = {r = 0, g = 0, b = 0, a = 0}
    local f5 = function(cU, cV, e2, cp, e5, bF, cl, f6, bO, f7, b8, type, f8)
        type = type or "default"
        f8 = f8 or 0
        local eK = renderer.load_svg(ba, 23, 23)
        if type == "default" then
            eV(cU, cV, e2, cp, e5, bF, cl, f6, f6)
            ae(cU + 42, cV + 3, 255, 255, 255, f6, nil, f7, bO)
            renderer.texture(eK, cU + 4, cV - 1, 23, 23, e5, bF, cl, f6, "f")
        elseif type == "notify" then
            local f9 = function(cU, cV, e2, cp, e5, bF, cl, d9)
                ab(cU, cV, e2, cp, 25, 25, 25, d9)
                renderer.triangle(cU, cV, cU, cV + cp, cU - 10, cV + cp, 25, 25, 25, d9)
                renderer.triangle(cU + e2, cV, cU + e2, cV + cp, cU + e2 + 10, cV, 25, 25, 25, d9)
                ac(cU - 1, cV - 2, e2 + 11, 2, cl, bF, e5, d9, e5, bF, cl, d9, true)
                af(cU, cV - 2, cU - 10, cV - 2 + cp + 1, cl, bF, e5, d9)
                af(cU - 1, cV - 2, cU - 1 - 10, cV - 2 + cp + 1, cl, bF, e5, d9)
                af(cU - 2, cV - 2, cU - 2 - 10, cV - 2 + cp + 1, cl, bF, e5, d9)
                af(cU + e2 + 11, cV - 1, cU + e2 + 11 - 10, cV - 1 + cp, 10, 10, 10, d9)
            end
            f9(cU, cV, e2, cp, e5, bF, cl, f6, f6)
            ae(cU + 35, cV + 3, 255, 255, 255, f6, nil, f7, bO)
            renderer.texture(eK, cU + 4, cV - 1, 23, 23, e5, bF, cl, f6, "f")
            local fa = function(fb)
                if fb < 0 then
                    fb = 0
                end
                if fb > 1 then
                    fb = 1
                end
                local e5 = math.floor(255 * (1 - fb))
                local bF = math.floor(255 * fb)
                local cl = 0
                return e5, bF, cl
            end
            local fc, fd, fe = fa(f8)
            local ff = e2 / 2 - 2
            ab(cU, cV - 8, ff + 2, 5, 25, 25, 25, f6 / 3)
            ab(cU + 1, cV - 6, ff * f8 > ff and ff or ff * f8, 1, fc, fd, fe, f6)
            ae(cU + ff + 2, cV - 12, 255, 255, 255, f6, "-", f7, string.format("%.2f", f8 * 2.5))
        end
    end
    b1.notify_alpha = 0
    b1.render_notify = function()
        local ck = function(cl, cm, cn, co)
            local bE, bF, cp
            local bt = aq(cl * 6)
            local cq = cl * 6 - bt
            local bA = cn * (1 - cm)
            local bB = cn * (1 - cq * cm)
            local b3 = cn * (1 - (1 - cq) * cm)
            bt = bt % 6
            if bt == 0 then
                bE, bF, cp = cn, b3, bA
            elseif bt == 1 then
                bE, bF, cp = bB, cn, bA
            elseif bt == 2 then
                bE, bF, cp = bA, cn, b3
            elseif bt == 3 then
                bE, bF, cp = bA, bB, cn
            elseif bt == 4 then
                bE, bF, cp = b3, bA, cn
            elseif bt == 5 then
                bE, bF, cp = cn, bA, bB
            end
            return bE * 255, bF * 255, cp * 255, co * 255
        end
        local cr = a9(b3.noti_time) / 10
        local bk = N() % cr / cr
        local cs = 1 - math.abs(bk * 2 - 1)
        local ct, cu, cv = ck(cs, 1, 1, 1)
        if a9(b3.noti_rgb) then
            a4(b3.noti_color, ct, cu, cv, 255)
        end
        local ef, eg = h()
        local cV = eg / 4 + 15
        for bA, fg in pairs(b1.notify.tb) do
            if fg.text ~= nil and fg.text ~= " " then
                b1.notify_alpha = aW.new(b1.notify_alpha, 1, 0, b0.table_contain(a9(b3.indicator), "notify"), 12)
                local e5, bF, cl, d9 = a9(b3.noti_color)
                local fh, fi = ag("", nil, fg.text)
                local f8 = aW.counter(fh + 60, fg.timer, fg.counter)
                fg.alpha = aW.new(fg.alpha, 0, 1, fg.timer + fg.counter + 0.2 < globals.realtime(), 6)
                f5(
                    ef / 4 - 200,
                    cV,
                    (fh + 25) * fg.alpha,
                    20,
                    e5,
                    bF,
                    cl,
                    d9 * b1.notify_alpha * fg.alpha,
                    fg.text,
                    fh * fg.alpha,
                    fg.alpha * b1.notify_alpha,
                    "notify",
                    f8
                )
            end
            if fg.timer + fg.counter + 1 < globals.realtime() then
                aG(b1.notify.tb, bA)
            end
            cV = cV - 32 * fg.alpha
        end
    end
    b1.notify.paint = function(bO, f8)
        table.insert(b1.notify.tb, {text = bO, alpha = 0, timer = N(), counter = f8})
    end
    b1.notify.paint("Welcome BACK! " .. "Rinne", 5)
    b1.defn_alpha = 0
    b1.active_alpha = 0
    b1.defn_rect_alpha = 0
    b1.active_rect_alpha = 0
    b1.dt_rect = 0
    b1.defen_tracker = function()
        if y() == nil then
            return
        end
        local fj = renderer.load_svg(bb, 25, 25)
        local ef, eg = h()
        local e5, bF, cl, d9 = a9(b3.defn_color)
        local ck = function(cl, cm, cn, co)
            local bE, bF, cp
            local bt = aq(cl * 6)
            local cq = cl * 6 - bt
            local bA = cn * (1 - cm)
            local bB = cn * (1 - cq * cm)
            local b3 = cn * (1 - (1 - cq) * cm)
            bt = bt % 6
            if bt == 0 then
                bE, bF, cp = cn, b3, bA
            elseif bt == 1 then
                bE, bF, cp = bB, cn, bA
            elseif bt == 2 then
                bE, bF, cp = bA, cn, b3
            elseif bt == 3 then
                bE, bF, cp = bA, bB, cn
            elseif bt == 4 then
                bE, bF, cp = b3, bA, cn
            elseif bt == 5 then
                bE, bF, cp = cn, bA, bB
            end
            return bE * 255, bF * 255, cp * 255, co * 255
        end
        local cr = a9(b3.noti_time) / 10
        local bk = N() % cr / cr
        local cs = 1 - math.abs(bk * 2 - 1)
        local ct, cu, cv = ck(cs, 1, 1, 1)
        if a9(b3.noti_rgb) then
            a4(b3.defn_color, ct, cu, cv, 255)
        end
        b1.defn_alpha = aW.new(b1.defn_alpha, 1, 0, b0.table_contain(a9(b3.indicator), "defensive tracker"), 12)
        b1.active_alpha = aW.new(b1.active_alpha, 1, 0, a9(aX.doubletap[1]) == true and a9(aX.doubletap[2]) == true, 6)
        b1.active_rect_alpha = aW.new(b1.active_rect_alpha, 1, 0, b1.active_alpha >= 0.95, 6)
        b1.dt_rect = aW.new(b1.dt_rect, 1, 0, b1.active_alpha >= 0.95 and c4(), 6)
        b1.defn_rect_alpha = aW.new(b1.defn_rect_alpha, 1, 0, b6.is_defensive_active(), 12)
        local fk, fl = ef / 2 - 25 / 2, eg / 8
        renderer.texture(
            fj,
            fk - 10 + 1,
            fl * b1.active_alpha - 1,
            25,
            25,
            0,
            0,
            0,
            d9 * b1.active_alpha * b1.defn_alpha,
            "f"
        )
        renderer.texture(
            fj,
            fk - 10 - 1,
            fl * b1.active_alpha + 1,
            25,
            25,
            0,
            0,
            0,
            d9 * b1.active_alpha * b1.defn_alpha,
            "f"
        )
        renderer.texture(
            fj,
            fk - 10 + 1,
            fl * b1.active_alpha + 1,
            25,
            25,
            0,
            0,
            0,
            d9 * b1.active_alpha * b1.defn_alpha,
            "f"
        )
        renderer.texture(
            fj,
            fk - 10 - 1,
            fl * b1.active_alpha - 1,
            25,
            25,
            0,
            0,
            0,
            d9 * b1.active_alpha * b1.defn_alpha,
            "f"
        )
        renderer.texture(
            fj,
            fk - 10,
            fl * b1.active_alpha,
            25,
            25,
            e5,
            bF,
            cl,
            d9 * b1.active_alpha * b1.defn_alpha,
            "f"
        )
        local fm, fn = 450, 5
        ab(
            fk - fm / 2 - 6 + 1,
            fl + 35 - 6 + 1,
            fm * b1.active_alpha + 12,
            fn + 12,
            12,
            12,
            12,
            255 * b1.active_alpha * b1.defn_alpha
        )
        ab(
            fk - fm / 2 - 6,
            fl + 35 - 6,
            fm * b1.active_alpha + 12,
            fn + 12,
            12,
            12,
            12,
            255 * b1.active_alpha * b1.defn_alpha
        )
        ab(
            fk - fm / 2 - 5,
            fl + 35 - 5,
            fm * b1.active_alpha + 10,
            fn + 10,
            40,
            40,
            40,
            255 * b1.active_alpha * b1.defn_alpha
        )
        ab(
            fk - fm / 2 - 4,
            fl + 35 - 4,
            fm * b1.active_alpha + 8,
            fn + 8,
            e5,
            bF,
            cl,
            d9 / 3 * b1.active_alpha * b1.defn_alpha
        )
        ab(
            fk - fm / 2 - 3,
            fl + 35 - 3,
            fm * b1.active_alpha + 6,
            fn + 6,
            40,
            40,
            40,
            255 * b1.active_alpha * b1.defn_alpha
        )
        ab(
            fk - fm / 2 - 4,
            fl + 35 - 4,
            (fm * b1.active_alpha + 6) * b1.defn_rect_alpha,
            fn + 8,
            e5,
            bF,
            cl,
            d9 / 3 * b1.active_alpha * b1.defn_alpha
        )
        ab(
            fk - fm / 2 - 4 + 1,
            fl + 35 - 4 + 15,
            (fm + 5) * b1.active_alpha,
            8 * b1.active_rect_alpha,
            10,
            10,
            10,
            255 * b1.active_alpha
        )
        ab(
            fk - fm / 2 - 4 + 3,
            fl + 35 - 4 + 16,
            (fm + 5 - 5) * b1.active_alpha * b1.dt_rect,
            5 * b1.active_rect_alpha,
            cl,
            bF,
            e5,
            d9 / 2 * b1.dt_rect * b1.active_alpha
        )
    end
    b1.hitlog = {}
    b1.hitlog.miss = function(co)
        if co == nil then
            return
        end
        local fo = {"Body", "Head", "Chest", "Stomach", "Left arm", "Right arm", "Left leg", "Right leg", "Neck", "?"}
        local fp = fo[co.hitgroup + 1] or "?"
        local fq = entity.get_player_name(co.target)
        local fr
        if co.reason == "?" then
            fr = "resolver"
        else
            fr = co.reason
        end
        local fs = "Missed " .. string.lower(fq) .. ", Group: " .. fp .. ", Reason: " .. fr
        b1.notify.paint(fs, 4)
    end
    b1.hitlog.hurt = function(co)
        local ft = client.userid_to_entindex(co.attacker)
        if ft == nil then
            return
        end
        if ft ~= entity.get_local_player() then
            return
        end
        local fo = {"Body", "Head", "Chest", "Stomach", "Left arm", "Right arm", "Left leg", "Right leg", "Neck", "?"}
        local fp = fo[co.hitgroup + 1] or "?"
        local fu = client.userid_to_entindex(co.userid)
        local fq = entity.get_player_name(fu)
        local fv = entity.get_prop(fu, "m_iHealth")
        local fw = fv - co.dmg_health
        if fw <= 0 then
            fw = 0
        end
        local fs =
            "Hit " ..
            string.lower(fq) .. ", Group: " .. fp .. "  Damage: " .. co.dmg_health .. "  Health remain: " .. fw
        if fw <= 0 then
            fs = fs .. " (death)"
        end
        b1.notify.paint(fs, 4)
    end
    local fx = {}
    fx.antik = function()
        local cK = function(cL, cM, cN, cO, cP, cQ)
            return math.sqrt((cO - cL) ^ 2 + (cP - cM) ^ 2 + (cQ - cN) ^ 2)
        end
        if b0.table_contain(a9(b3.features), "anti-knife") then
            local eo = entity.get_players(true)
            local cR, cS, cT = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
            local dw, fy = ui.reference("AA", "Anti-aimbot angles", "Yaw")
            local dv = ui.reference("AA", "Anti-aimbot angles", "Pitch")
            for bt = 1, #eo do
                local cU, cV, cW = entity.get_prop(eo[bt], "m_vecOrigin")
                local df = cK(cR, cS, cT, cU, cV, cW)
                local c5 = entity.get_player_weapon(eo[bt])
                if entity.get_classname(c5) == "CKnife" and df <= a9(b3.misc_antidis) then
                    ui.set(fy, 180)
                end
            end
        end
    end
    local fz, fA = 0, 0
    fx.anim = function()
        if b0.table_contain(a9(b3.features), "anim. breaker") then
            if not entity.is_alive(entity.get_local_player()) then
                return
            end
            if b0.table_contain(a9(b3.m_animbreak), "in air") then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
            end
            if b0.table_contain(a9(b3.m_animbreak), "on land") then
                local cJ = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
                if cJ == 1 then
                    fz = fz + 1
                else
                    fz = 0
                    fA = globals.curtime() + 1
                end
                if fz > ui.get(aX.fake_lag_limit) + 1 and fA > globals.curtime() then
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
                end
            end
            local fB = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
            if b0.table_contain(a9(b3.m_animbreak), "leg fucker") then
                ui.set(aX.leg_movement, fB[2])
                H(y(), "m_flPoseParameter", 8, 0)
            end
        end
    end
    b1.render = function()
        b1.center()
        b1.arrows_render()
        b1.defen_tracker()
    end
    local fC = require("gamesense/clipboard")
    aV.console_input = function(co)
        if aK(co, "/import config") then
            n("playvol buttons/arena_switch_press_02 1")
            b0.load(b2.register_ui, fC.get())
        elseif aK(co, "/export config") then
            n("playvol buttons/arena_switch_press_02 1")
            fC.set(b0.exp(b2.register_ui))
        elseif aK(co, "/import aaconfig") then
            n("playvol buttons/arena_switch_press_02 1")
            b0.load(b2.register_aa, fC.get())
        elseif aK(co, "/export aaconfig") then
            n("playvol buttons/arena_switch_press_02 1")
            fC.set(b0.exp(b2.register_aa))
        end
    end
    b0._call = function(bd, fD)
        for fE, bp in pairs(bd) do
            ui.set_callback(bp, fD)
        end
    end
    b4.setup_command = function(da)
        b6.setup_anti(da)
        fx.antik()
    end
    b4.paint_ui = function()
        b5.visible()
        b6.run_paint()
        local fF = {Z("VISUALS", "Player ESP", "Glow")}
        local fG = {Z("VISUALS", "Colored models", "Player behind wall")}
        local ck = function(cl, cm, cn, co)
            local bE, bF, cp
            local bt = aq(cl * 6)
            local cq = cl * 6 - bt
            local bA = cn * (1 - cm)
            local bB = cn * (1 - cq * cm)
            local b3 = cn * (1 - (1 - cq) * cm)
            bt = bt % 6
            if bt == 0 then
                bE, bF, cp = cn, b3, bA
            elseif bt == 1 then
                bE, bF, cp = bB, cn, bA
            elseif bt == 2 then
                bE, bF, cp = bA, cn, b3
            elseif bt == 3 then
                bE, bF, cp = bA, bB, cn
            elseif bt == 4 then
                bE, bF, cp = b3, bA, cn
            elseif bt == 5 then
                bE, bF, cp = cn, bA, bB
            end
            return bE * 255, bF * 255, cp * 255, co * 255
        end
        local cr = a9(b3.noti_time) / 10
        local bk = N() % cr / cr
        local cs = 1 - math.abs(bk * 2 - 1)
        local ct, cu, cv = ck(cs, 1, 1, 1)
        local e5, bF, cl, d9 = a9(fF[2])
        if a9(b3.noti_rgb) then
            a4(fF[2], ct, cu, cv, d9)
            a4(fG[2], ct, cu, cv, 255)
        end
        b1.on_load()
        b1.render_notify()
    end
    b4.paint = function()
        b1.render()
    end
    b4.on_aim_miss = function(co)
        b1.hitlog.miss(co)
    end
    b4.on_player_hurt = function(co)
        b1.hitlog.hurt(co)
    end
    b4.on_player_death = function(co)
        if client.userid_to_entindex(co.userid) == entity.get_local_player() then
            b1.notify.paint("Reseted data due to death", 5)
        end
    end
    b4.on_round_start = function(co)
        if entity.get_local_player() == nil then
            return
        end
        b1.notify.paint("Reseted data due to round start", 7)
    end
    b4.on_game_newmap = function(co)
        if entity.get_local_player() == nil then
            return
        end
        b1.notify.paint("Reseted data due to change map", 7)
    end
    b4.on_client_disconnect = function()
        b1.notify.paint("Disconnected to the server", 10)
    end
    b4.pre_render = function()
        fx.anim()
    end
    b4.paint_ui()
    b4._register = function()
        g("console_input", aV.console_input)
        g("paint_ui", b4.paint)
        g("paint_ui", b4.paint_ui)
        g("setup_command", b4.setup_command)
        g("pre_render", b4.pre_render)
        g("player_death", b4.on_player_death)
        g("round_start", b4.on_round_start)
        g("game_newmap", b4.on_game_newmap)
        g("client_disconnect", b4.on_client_disconnect)
        g("aim_miss", b4.on_aim_miss)
        g("player_hurt", b4.on_player_hurt)
    end
    b0._call(b2.register_data, b5.visible)
    b4._register()
end

    b9()

