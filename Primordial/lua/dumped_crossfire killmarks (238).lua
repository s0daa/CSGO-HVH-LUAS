local killstreak = 0
local set_headshot = false
local killstreak_count = 0
local w, h = render.get_screen_size().x, render.get_screen_size().y 


local file_crc_status_e = {cant_open_file = 0, got_crc = 1, file_in_vpk = 2}
local vftable_e = {filesystem = {check_cached_file_hash = 56}}
local IFileSystem =
    ffi.cast(
    "int*",
    memory.create_interface("filesystem_stdio.dll", "VFileSystem017") or
        error('IFileSystem could not be accessed through filesystem_stdio.dll!CreateInterface("VFileSystem017")')
)

callbacks.add(
    e_callbacks.PAINT,
    function()
        IFileSystem[vftable_e.filesystem.check_cached_file_hash] = file_crc_status_e.got_crc
    end
)
 

 
 
local img = {
	render.load_image("primordial\\scripts\\killmarks\\first.png"),
	render.load_image("primordial\\scripts\\killmarks\\second.png"),
	render.load_image("primordial\\scripts\\killmarks\\third.png"),
	render.load_image("primordial\\scripts\\killmarks\\fourth.png"),
	render.load_image("primordial\\scripts\\killmarks\\fifth.png"),
	render.load_image("primordial\\scripts\\killmarks\\sixth.png"),
	[true] = render.load_image("primordial\\scripts\\killmarks\\hs.png"),
}
 
local delay = 4
local proxtime = 0

callbacks.add(e_callbacks.PAINT, function()
        cur_time = global_vars.real_time()
        if cur_time - proxtime < delay and killstreak_count ~= killstreak then
            --	render.texture(img[killstreak].id, vec2_t(w / 2 - 76, h / 2 + h / 3 - h / 24), vec2_t(158, 158))
            if set_headshot then
                render.texture(img[set_headshot].id, vec2_t(w / 2 - 76, h / 2 + h / 3 - h / 24), vec2_t(158, 158))
                return
            end

            if killstreak == 0 then
                return
            end
            if killstreak < 6 then
                render.texture(img[killstreak].id, vec2_t(w / 2 - 76, h / 2 + h / 3 - h / 24), vec2_t(158, 158))
            else
                render.texture(img[6].id, vec2_t(w / 2 - 76, h / 2 + h / 3 - h / 24), vec2_t(158, 158))
            end
        elseif killstreak ~= killstreak_count then
            killstreak_count = killstreak
        else
            proxtime = cur_time
        end
end)


-- Reset
local function reset()
    killstreak = 0
    set_headshot = false
	killstreak_count = 0
end

local function events_(e)
    if entity_list.get_player_from_userid(e.userid) == entity_list.get_local_player() then
        reset()
    elseif entity_list.get_local_player() == entity_list.get_player_from_userid(e.attacker) then
      
 		killstreak = killstreak + 1
		--[[	
        killstreak = killstreak < 6 and killstreak or 6]]
        set_headshot = e.headshot
    end
end
callbacks.add(e_callbacks.EVENT, events_, "player_death")

local function round_end(e)
	reset()
end
 
callbacks.add(e_callbacks.EVENT, round_end,"round_end")

local function  round_start(e)
	reset()
end
callbacks.add(e_callbacks.EVENT, round_end,"round_start")