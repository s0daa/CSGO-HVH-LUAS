local a, b, c, d, e, f, g, h, i, j, pairs = entity.get_player_weapon, entity.get_players, entity.get_prop, globals.curtime, globals.tickinterval, math.floor, plist.set, ui.get, ui.reference, ui.set, pairs;
local k = { enabled = false, ref_targethitbox = i('RAGE', 'Aimbot', 'Target hitbox'), ref_multipoint = i('RAGE', 'Aimbot', 'Multi-point'), cached_targethitbox = {}, cached_target_hitbox = {}, set_whitelist = {} }
function k.on_enable()
    if k.enabled then
        return
    end ;
    k.cached_multipoint = h(k.ref_multipoint)
    k.cached_target_hitbox = h(k.ref_targethitbox)
    j(k.ref_multipoint, { 'head' })
    j(k.ref_targethitbox, { 'head' })
    k.enabled = true
end;
function k.on_disable()
    if not k.enabled then
        return
    end ;
    j(k.ref_multipoint, k.cached_multipoint)
    j(k.ref_targethitbox, k.cached_target_hitbox)
    local l = b(true)
    if k.set_whitelist[ent] then
        g(ent, 'add to whitelist', false)
    end ;
    k.set_whitelist = {}
    k.enabled = false
end;
function k.handle()
    local m = f(0.2 / e())
    local l = b(true)
    for n, ent in pairs(l) do
        local o = a(ent)
        local p = c(o, 'm_fLastShotTime')
        if p then
            local q = d() - p;
            local r = q / e()
            g(ent, 'add to whitelist', r > m and k.enabled)
            k.set_whitelist[ent] = r > m and k.enabled
        end
    end
end;
return k