local motions = {
    "standing",
    "walking",
    "running",
    "in air",
    "peeking",
}
local enable = menu.add_checkbox("lua", "Fakelag", false)
local shot_send = menu.add_checkbox("lua", "send pack when shot", false)
local enabled_motions = menu.add_multi_selection("lua", "enabled motions", motions)
local current_motions = menu.add_selection("lua", "current motion", motions)
local fakelag_c = {

}
table.insert(motions,1,"global")
for key, value in pairs(motions) do
    fakelag_c[value] = {}
    fakelag_c[value]["mode"] = menu.add_selection(value, "mode", {"max","random","step","switch"})
    fakelag_c[value]["value"] = menu.add_slider(value, "choke", 1, 14)
    fakelag_c[value]["value1"] = menu.add_slider(value, "choke min", 1, 14)
    fakelag_c[value]["value2"] = menu.add_slider(value, "choke max", 1, 14)
end
local old_enabled_motions = {}
local fresh_current_motions = function ()
    local enabled_c = {
        "global"
    }
    for key, value in pairs(enabled_motions:get_items()) do
        if enabled_motions:get(value) then
            table.insert(enabled_c, value)
      
        end
    end
    current_motions:set_items(enabled_c)
end

local function menu_hanlde()
    for key, value in pairs(motions) do
        local cache_table = current_motions:get_items()
     if cache_table[current_motions:get()] == value then
        menu.set_group_column(value, 1)
        local cache_table = fakelag_c[value]["mode"]:get_items()
        if cache_table[fakelag_c[value]["mode"]:get()] == "max" then
            fakelag_c[value]["value"]:set_visible(true)
            fakelag_c[value]["value1"]:set_visible(false)
            fakelag_c[value]["value2"]:set_visible(false)
        else
            fakelag_c[value]["value"]:set_visible(false)
            fakelag_c[value]["value1"]:set_visible(true)
            fakelag_c[value]["value2"]:set_visible(true)
        end
        menu.set_group_visibility(value,true)
    else
        menu.set_group_visibility(value, false)
    end
    end
end
local function ent_speed(index)
    local pos = index:get_prop('m_vecVelocity')
    if pos.x == nil then
        return 0
    end
    return math.sqrt(pos.x * pos.x + pos.y * pos.y + pos.z * pos.z)
end
local function OnGround (entindex)
    return (bit.band(entindex:get_prop('m_fFlags'), 1) ~= 0)
end
local _,slow_walk_ui = unpack(menu.find("misc","main","movement","slow walk"))

local function get_motion()
    local local_player = entity_list.get_local_player()
    if enabled_motions:get("peeking")  then
      
        local pos = local_player:get_eye_position()
        local vel = local_player:get_prop( "m_vecVelocity")


        local speed = 220
      
       
        local predicted_pos = vec3_t(
            pos.x + (vel.x / speed) * 128,
            pos.y + (vel.y / speed) * 128,
            pos.z + (vel.z / speed) * 128
    )
        for k, v in pairs(entity_list.get_players(true)) do
            local head = v:get_hitbox_pos(e_hitboxes.HEAD)
            local pelvis = v:get_hitbox_pos(e_hitboxes.PELVIS)
            local  head_ent =trace.line(predicted_pos,head,lp).entity
              
            local  pelvis_ent = trace.line(predicted_pos,pelvis,lp).entity

            if head_ent == v or pelvis_ent == v then
                
                local  head_ent = trace.line(pos,head,lp).entity
                local  pelvis_ent = trace.line(pos,pelvis,lp).entity
                if head_ent ~= v and pelvis_ent ~= v then
                    return "peeking"
                end
            end
        end
     
    end
    if enabled_motions:get("in air") and not OnGround(local_player) then
        return "in air"
    end
    if enabled_motions:get("walking") and slow_walk_ui:get() then
        return "walking"
    end
    if enabled_motions:get("standing") and ent_speed(local_player) <4 then
        return "standing"
    elseif enabled_motions:get("running") then
        return "running"
    end
    return "global"
end

callbacks.add(e_callbacks.PAINT, function ()
    menu_hanlde()
    fresh_current_motions()
end)
local final = 0
local step_c = 1
local switch_c = false
callbacks.add(e_callbacks.ANTIAIM, function (ctx)
   if enable:get() then else return end
   local choke_cmd =  engine.get_choked_commands()
   local lp = entity_list.get_local_player()


   local tk = global_vars.interval_per_tick() * 14
   local wp = lp:get_active_weapon()
   local aw = wp ~= nil and global_vars.cur_time() < wp:get_prop("m_fLastShotTime") + tk
   if choke_cmd < final then
   
    ctx:set_fakelag( not (aw and shot_send:get()) )
   else
    ctx:set_fakelag(false)
   end
   if choke_cmd == 0 then
    final = 0
   local cur_motion = get_motion()
   if cur_motion == nil then return end
    if fakelag_c[cur_motion]["mode"]:get() == 1 then
        final = fakelag_c[cur_motion]["value"]:get()
    else
        if fakelag_c[cur_motion]["mode"]:get() == 2 then
            final = math.random(fakelag_c[cur_motion]["value1"]:get(),fakelag_c[cur_motion]["value2"]:get())
        elseif fakelag_c[cur_motion]["mode"]:get() == 3 then
            if step_c >= fakelag_c[cur_motion]["value2"]:get() then
                step_c = fakelag_c[cur_motion]["value1"]:get()
            end
            step_c = step_c + 1
            final = step_c
        else
            if switch_c then
            final = fakelag_c[cur_motion]["value1"]:get()
            else
            final = fakelag_c[cur_motion]["value2"]:get()
            end
            switch_c = not switch_c
        end
    end
   
   end

end)