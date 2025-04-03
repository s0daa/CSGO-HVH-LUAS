local api = {}

function api:time_to_timestamp(u)
if u == nil or u == 0 then return end
local h = math.floor(u / 3600)
local m = math.floor( ( u / 60 ) % 60 )
local ml = ( u - math.floor( u ) ) * 100
u = math.floor( u % 60 )
   return h, m, u, ml
end

function api:float_to_desync(fl, round)
local r_v = round and math.floor(60*fl+0.5) or 60*fl
   return r_v
end

function api:desync_to_float(des, round)
local r_v = round and math.floor(des/60+0.5) or des/60
   return r_v
end

function api:cs_session_time()
    return api:time_to_timestamp(global_vars.real_time())
end

function api:freeze_time()
   return engine.is_in_game() and engine.is_connected() and game_rules.get_prop("m_bFreezePeriod") == 1
end

function api:is_warmup()
   return engine.is_in_game() and engine.is_connected() and game_rules.get_prop("m_bWarmupPeriod") == 1
end

function api:get_pos_tbl(tbl)
local val = {}
local id = 0
   for k, v in pairs(tbl) do
      id = id + 1
      val[id] = k
   end
   return val
end

function api:print_tbl(tbl)
   local pos = api:get_pos_tbl(tbl)
   table.sort(pos, function(a, b)
      if (type(a) == "number" and type(b) == "number") then return a < b end
      return tostring(a) < tostring(b)
   end)
   for i=1, #pos do
   local key = pos[i]
   local val = tbl[key]
   if type(val) == "table" then
   print(key .. " = {")
   api:print_tbl(val)
   print("}")
   else
   print(key, " = ", val) 
   end
   end
end

function api:clamp(num, m, mx)
   return math.min(math.max(num, m), mx)
end

local b_s = {
   [0] = "A",
   [1] = "B"
}
function api:get_bomb_site()
   if not engine.is_in_game() or not engine.is_connected() then return end
   return b_s[game_rules.get_prop("m_iBombSite")] or game_rules.get_prop("m_iBombSite")
end

function api:get_velocity(ent)
   if ent == nil then return end
   local v = ent:get_prop("m_vecVelocity")
   return math.sqrt(v.x ^ 2 + v.y ^ 2)
end

function api:dist_to(a, b)
if a == nil or b == nil then return end
local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
   return math.sqrt(dx * dx + dy * dy + dz * dz)
end

return api