

-- menu references
local hs = gui.get_config_item("Rage>Aimbot>Aimbot>Hide shot")
local limit = gui.get_config_item("Rage>Anti-Aim>Fakelag>Limit")

-- cache fakelag limit
local cache = {
  backup = limit:get_int(),
  override = false,
}

-- fakelag limit 1 on hs
function on_paint()

  if hs:get_bool() then
    limit:set_int(1)
    cache.override = true
  else
    if cache.override then
      limit:set_int(cache.backup)
      cache.override = false
    else
      cache.backup = limit:get_int()
    end
  end
end