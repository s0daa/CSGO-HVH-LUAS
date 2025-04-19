local exec = client.exec
local userid_to_entindex = client.userid_to_entindex
local get_local_player = entity.get_local_player
local ui_get = ui.get

local alt_hitmarker_enable = ui.new_checkbox("MISC", "Miscellaneous", "Custom Hitmarker Sound")

local function on_player_hurt(e)
  if not ui_get(alt_hitmarker_enable) then return end

  local attacker_userid = e.attacker

  if attacker_userid == nil then return end

  local attacker_entindex = userid_to_entindex(attacker_userid)

  if attacker_entindex == get_local_player() then
    exec("playvol */bell.wav 1")
  end
end

client.set_event_callback("player_hurt", on_player_hurt)