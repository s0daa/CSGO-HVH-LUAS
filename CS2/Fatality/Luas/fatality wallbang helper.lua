-- Waypoint
-- best nonprime cfg - https://fatality.win/resources/2355/
local waypoints = {}
local waypoint_font = draw.font("verdana.ttf", 12, draw.font_flags.outline)
local add_waypoint_cb = gui.checkbox(gui.control_id("lua>elements a>add_waypoint"))
local clear_waypoint_cb = gui.checkbox(gui.control_id("lua>elements b>clear_waypoint"))

local add_row = gui.make_control("Add Waypoint [Click]", add_waypoint_cb)
local clear_row = gui.make_control("Clear Last Waypoint", clear_waypoint_cb)
local groupA = gui.ctx:find("lua>elements a")
local groupB = gui.ctx:find("lua>elements b")
groupA:add(add_row)
groupB:add(clear_row)
-- Previous states
local prev_states = { add = false, clear = false }
-- Predefined waypoint data (one way data)
local predefined_waypoints = {
--de_Mirage Cords
{ label = "Waypoint 1" , pos = vector(703.59, -1603.12, -262.88), map ="de_mirage"},
{ label = "Waypoint 2" , pos = vector(-1039.57, -327.51, -367.97), map ="de_mirage"},
{ label = "Waypoint 3" , pos = vector(605.47, -1718.96, -258.09), map ="de_mirage"},
{ label = "Waypoint 4" , pos = vector(-1005.98, -2480.60, -167.97), map ="de_mirage"},
{ label = "Waypoint 5" , pos = vector(576.92, -1717.41, -259.04), map ="de_mirage"},
{ label = "Waypoint 6" , pos = vector(12.23, -2093.41, -39.97), map ="de_mirage"},
{ label = "Waypoint 7" , pos = vector(509.55, -1665.90, -263.97), map ="de_mirage"},
{ label = "Waypoint 8" , pos = vector(459.30, -2343.78, -39.97), map ="de_mirage"},
{ label = "Waypoint 9" , pos = vector(444.76, -1710.55, -234.35), map ="de_mirage"},
{ label = "Waypoint 10" , pos = vector(1039.96, -1909.43, -71.97), map ="de_mirage"},
{ label = "Waypoint 11" , pos = vector(430.87, -1523.46, -227.40), map ="de_mirage"},
{ label = "Waypoint 12" , pos = vector(-675.45, -780.14, -262.05), map ="de_mirage"},
{ label = "Waypoint 13" , pos = vector(487.58, -1601.25, -255.76), map ="de_mirage"},
{ label = "Waypoint 14" , pos = vector(527.97, -534.74, -155.97), map ="de_mirage"},
{ label = "Waypoint 15" , pos = vector(-647.06, -778.04, -261.97), map ="de_mirage"},
{ label = "Waypoint 16" , pos = vector(419.38, -1522.17, -221.65), map ="de_mirage"},
{ label = "Waypoint 17" , pos = vector(-628.49, -778.79, -261.97), map ="de_mirage"},
{ label = "Waypoint 18" , pos = vector(-142.97, -1418.03, -72.18), map ="de_mirage"},
{ label = "Waypoint 19" , pos = vector(-611.44, -767.45, -261.97), map ="de_mirage"},
{ label = "Waypoint 20" , pos = vector(-297.20, -1529.68, -167.97), map ="de_mirage"},
{ label = "Waypoint 21" , pos = vector(-600.88, -739.22, -262.38), map ="de_mirage"},
{ label = "Waypoint 22" , pos = vector(-391.37, -2031.91, -179.97), map ="de_mirage"},
{ label = "Waypoint 23" , pos = vector(-152.51, -934.70, -167.55), map ="de_mirage"},
{ label = "Waypoint 24" , pos = vector(-704.82, -814.35, -263.97), map ="de_mirage"},
{ label = "Waypoint 25" , pos = vector(-710.23, -812.21, -263.97), map ="de_mirage"},
{ label = "Waypoint 26" , pos = vector(-1374.63, -987.34, -167.97), map ="de_mirage"},
{ label = "Waypoint 27" , pos = vector(-999.98, -307.89, -367.97), map ="de_mirage"},
{ label = "Waypoint 28" , pos = vector(684.14, -1625.90, -262.55), map ="de_mirage"},
{ label = "Waypoint 29" , pos = vector(-1070.30, -2468.48, -167.97), map ="de_mirage"},
{ label = "Waypoint 30" , pos = vector(691.76, -1642.52, -258.56), map ="de_mirage"},
{ label = "Waypoint 31" , pos = vector(-1711.97, -1023.42, -203.92), map ="de_mirage"},
{ label = "Waypoint 32" , pos = vector(11.61, -607.98, -189.97), map ="de_mirage"},
{ label = "Waypoint 33" , pos = vector(-1671.04, 564.31, -167.97), map ="de_mirage"},
{ label = "Waypoint 34" , pos = vector(-1133.83, -786.66, -167.97), map ="de_mirage"},
{ label = "Waypoint 35" , pos = vector(-1567.95, 526.26, -167.97), map ="de_mirage"},
{ label = "Waypoint 36" , pos = vector(-1567.95, 526.26, -167.97), map ="de_mirage"},
{ label = "Waypoint 37" , pos = vector(-1054.21, 731.78, -79.97), map ="de_mirage"},
{ label = "Waypoint 38" , pos = vector(-1571.11, 525.77, -167.97), map ="de_mirage"},
{ label = "Waypoint 39" , pos = vector(-1449.30, 252.92, -166.97), map ="de_mirage"},
{ label = "Waypoint 40" , pos = vector(-1504.24, 750.58, -47.97), map ="de_mirage"},
{ label = "Waypoint 41" , pos = vector(-1633.51, 115.84, -168.39), map ="de_mirage"},
{ label = "Waypoint 42" , pos = vector(-752.04, -61.73, -161.07), map ="de_mirage"},
{ label = "Waypoint 43" , pos = vector(20.35, -2122.48, -39.97), map ="de_mirage"},
{ label = "Waypoint 44" , pos = vector(667.86, -1601.04, -263.97), map ="de_mirage"},
{ label = "Waypoint 45" , pos = vector(151.97, -2071.96, -39.97), map ="de_mirage"},
{ label = "Waypoint 46" , pos = vector(208.15, -1437.61, -175.97), map ="de_mirage"},
{ label = "Waypoint 47" , pos = vector(15.97, -1740.47, -167.97), map ="de_mirage"},
{ label = "Waypoint 48" , pos = vector(947.48, -2273.43, -39.97), map ="de_mirage"},
{ label = "Waypoint 49" , pos = vector(-129.66, -2412.97, -163.97), map ="de_mirage"},
{ label = "Waypoint 50" , pos = vector(468.79, -2337.59, -39.97), map ="de_mirage"},
{ label = "Waypoint 51" , pos = vector(735.97, -2390.94, 10.63), map ="de_mirage"},
{ label = "Waypoint 52" , pos = vector(-282.84, -2399.04, -163.97), map ="de_mirage"},
{ label = "Waypoint 53" , pos = vector(1179.10, -1479.96, -167.97), map ="de_mirage"},
{ label = "Waypoint 54" , pos = vector(878.89, -2009.50, -71.97), map ="de_mirage"},
{ label = "Waypoint 55" , pos = vector(-552.23, -1310.53, -163.97), map ="de_mirage"},
{ label = "Waypoint 56" , pos = vector(-453.46, -1798.52, -175.77), map ="de_mirage"},
{ label = "Waypoint 57" , pos = vector(-1504.52, -1420.02, -259.97), map ="de_mirage"},
{ label = "Waypoint 58" , pos = vector(-327.19, -2037.79, -175.18), map ="de_mirage"},
{ label = "Waypoint 59" , pos = vector(-1525.03, -1474.21, -259.97), map ="de_mirage"},
{ label = "Waypoint 60" , pos = vector(-494.80, -702.30, -267.72), map ="de_mirage"},
{ label = "Waypoint 61" , pos = vector(-1504.39, -1440.34, -259.97), map ="de_mirage"},
{ label = "Waypoint 62" , pos = vector(-1156.04, -1248.18, -167.97), map ="de_mirage"},
{ label = "Waypoint 63" , pos = vector(-1556.84, -950.87, -191.93), map ="de_mirage"},
{ label = "Waypoint 64" , pos = vector(-1041.40, -300.32, -367.97), map ="de_mirage"},
{ label = "Waypoint 65" , pos = vector(-1041.40, -300.32, -367.97), map ="de_mirage"},
{ label = "Waypoint 66" , pos = vector(-1572.53, -1607.21, -263.62), map ="de_mirage"},
{ label = "Waypoint 67" , pos = vector(-1961.60, -472.47, -167.97), map ="de_mirage"},
{ label = "Waypoint 68" , pos = vector(-1006.52, -321.76, -367.97), map ="de_mirage"},
{ label = "Waypoint 69" , pos = vector(-1128.40, 295.97, -159.97), map ="de_mirage"},
{ label = "Waypoint 70" , pos = vector(-436.49, 662.30, -79.64), map ="de_mirage"},
{ label = "Waypoint 71" , pos = vector(-1073.82, 297.22, -159.97), map ="de_mirage"},
{ label = "Waypoint 72" , pos = vector(-1012.98, 546.72, -79.97), map ="de_mirage"},
{ label = "Waypoint 73" , pos = vector(-1839.26, 241.86, -162.15), map ="de_mirage"},
{ label = "Waypoint 74" , pos = vector(-982.12, 327.82, -367.97), map ="de_mirage"},
{ label = "Waypoint 75" , pos = vector(-913.93, 112.04, -170.46), map ="de_mirage"},
{ label = "Waypoint 76" , pos = vector(-1011.93, -163.11, -348.30), map ="de_mirage"},
{ label = "Waypoint 77" , pos = vector(-2004.44, 682.37, -46.56), map ="de_mirage"},
{ label = "Waypoint 78" , pos = vector(-1044.00, -333.05, -357.70), map ="de_mirage"},
{ label = "Waypoint 79" , pos = vector(-1038.34, 360.31, -367.97), map ="de_mirage"},
{ label = "Waypoint 80" , pos = vector(-1932.83, -356.13, -167.97), map ="de_mirage"},
{ label = "Waypoint 81" , pos = vector(-969.88, -378.17, -346.88), map ="de_mirage"},
{ label = "Waypoint 82" , pos = vector(187.10, 841.37, -135.97), map ="de_mirage"},
{ label = "Waypoint 83" , pos = vector(-1017.47, -456.40, -307.77), map ="de_mirage"},
{ label = "Waypoint 84" , pos = vector(-969.66, 240.66, -171.39), map ="de_mirage"},
{ label = "Waypoint 85" , pos = vector(-710.95, -821.33, -263.97), map ="de_mirage"},
{ label = "Waypoint 86" , pos = vector(-1255.57, -1440.03, -158.01), map ="de_mirage"},

--de_else idk go add urself
{ label = "Waypoint 87",pos = vector (820.49, 808.03, 47.03), map= "de_dust2"},
{ label = "Waypoint 88",pos = vector (311.44, 1786.08, 96.03), map= "de_dust2"},
{ label = "Waypoint 89",pos = vector (915.47, 2412.67, 127.03), map= "de_dust2"},
{ label = "Waypoint 90",pos = vector (291.23, 2415.40, -121.09), map= "de_dust2"},
{ label = "Waypoint 91",pos = vector (-364.10, 2145.41, -127.84), map= "de_dust2"},
{ label = "Waypoint 92",pos = vector (334.00, 1678.27, 43.28), map= "de_dust2"},
{ label = "Waypoint 93",pos = vector (362.84, 1636.50, 21.39), map= "de_dust2"},
{ label = "Waypoint 94",pos = vector (-166.03, 2172.27, -126.00), map= "de_dust2"},
{ label = "Waypoint 95",pos = vector (1146.69, 2276.10, 9.44), map= "de_dust2"},
{ label = "Waypoint 96",pos = vector (1356.49, 2533.70, 67.16), map= "de_dust2"},
{ label = "Waypoint 97",pos = vector (597.71, 457.31, 1.21), map= "de_dust2"},
{ label = "Waypoint 98",pos = vector (-541.42, 404.95, 5.82), map= "de_dust2"},
}
-- Function to add predefined waypoints
local function add_predefined_waypoints()
for _, waypoint in ipairs(predefined_waypoints) do
table.insert(waypoints, waypoint)
end
end
add_predefined_waypoints()
-- Get local player
local function get_local_pawn()
local local_pawn = entities.get_local_pawn()
return local_pawn
end
-- Get current map name
local function get_current_map()
return game.global_vars.map_name -- this variable holds the current map name
end
-- Format vector to string
local function format_vector(vec)
return string.format("%.2f, %.2f, %.2f", vec.x, vec.y, vec.z)
end
-- Print all waypoints to console
local function print_waypoints()
print("Current Waypoints:")
for i, waypoint in ipairs(waypoints) do
print(string.format("Waypoint %d at %s on map %s", i, format_vector(waypoint.pos), waypoint.map))
end
end
-- Add waypoint at current position
local function add_waypoint()
local pawn = get_local_pawn()
if not pawn then return end
local origin = pawn:get_abs_origin()
local current_map = get_current_map() -- Get current map name
local event_name = "Event Name" -- Replace with actual event name logic
table.insert(waypoints, { pos = origin, label = event_name, map = current_map }) -- Store event name and map
print("Added waypoint: " .. event_name .. " at " .. format_vector(origin) .. " on map " .. current_map)
-- Print all waypoints to console
print_waypoints()
-- Auto-reset checkbox
add_waypoint_cb:set_value(false)
end
local function clear_last_waypoint()
if #waypoints > 0 then
local removed_waypoint = table.remove(waypoints) -- Remove the last waypoint
print("Removed last waypoint: " .. removed_waypoint.label .. " at " .. format_vector(removed_waypoint.pos))
else
print("No waypoints to remove")
end

clear_waypoint_cb:set_value(false)
end

-- Check checkbox changes
local function check_controls()
-- Add waypoint (one-time trigger)
local current_add = add_waypoint_cb:get_value():get()
if current_add and not prev_states.add then
add_waypoint()
end
prev_states.add = current_add
-- Clear last waypoint (one-time trigger)
local current_clear = clear_waypoint_cb:get_value():get()
if current_clear and not prev_states.clear then
clear_last_waypoint()
end
prev_states.clear = current_clear
end
-- Check if any player is within a waypoint
local function is_player_near_waypoint(waypoint)
local nearby = false
entities.players:for_each(function(entry)
if entry.entity and entry.entity:is_enemy() then local player_pos = entry.entity:get_abs_origin()
if player_pos:dist(waypoint.pos) < 50 then
nearby = true
end
end
end)
return nearby
end
local function on_draw()
if #waypoints == 0 then return end
local d = draw.surface
d.font = waypoint_font
local local_pawn = get_local_pawn()
local current_map = get_current_map()
local trigger_radius = 50 -- For trigger detection
local render_radius = 300 -- For waypoint visibility
-- First pass: Check triggers and visibility
local triggered_waypoints = {}
local visible_waypoints = {}

for i = 1, #waypoints do
local waypoint = waypoints
if waypoint.map == current_map then
local distance_to_player = waypoint.pos:dist(local_pawn:get_abs_origin())

-- Check if waypoint is triggered
if local_pawn and (distance_to_player < trigger_radius or is_player_near_waypoint(waypoint)) then
triggered_waypoints = true

-- Make paired waypoint visible when triggered
local paired_index = (i % 2 == 1) and (i + 1) or (i - 1)
if paired_index >= 1 and paired_index <= #waypoints then
visible_waypoints[paired_index] = true
end
end
-- Waypoint is visible if:
-- 1. Within render radius OR
-- 2. Is triggered OR
-- 3. Its pair is triggered
if distance_to_player < render_radius or
triggered_waypoints or
(i % 2 == 1 and triggered_waypoints[i + 1]) or
(i % 2 == 0 and triggered_waypoints[i - 1]) then
visible_waypoints = true
end
end
end
-- Second pass: Draw lines for triggered waypoints
for i = 1, #waypoints do
if triggered_waypoints then
local waypoint = waypoints
local screen_pos = math.world_to_screen(waypoint.pos)

if waypoint.map == current_map then
local paired_index = (i % 2 == 1) and (i + 1) or (i - 1)
if paired_index >= 1 and paired_index <= #waypoints then
local paired_waypoint = waypoints[paired_index]
local paired_screen_pos = math.world_to_screen(paired_waypoint.pos)
if screen_pos and paired_screen_pos then
d:add_line(
screen_pos,
paired_screen_pos,
draw.color(255, 255, 255, 200),
1
)
end
end
end
end
end
-- Third pass: Render visible waypoints
for i = 1, #waypoints do
if not visible_waypoints then goto continue end

local waypoint = waypoints
local screen_pos = math.world_to_screen(waypoint.pos)

if screen_pos and waypoint.map == current_map then
local is_triggered = triggered_waypoints
local color = draw.color(255, 0, 0, 255) -- Default red
if i % 2 == 1 then
-- Odd waypoint
local next_even_index = i + 1
local even_is_triggered = next_even_index <= #waypoints and triggered_waypoints[next_even_index]

if is_triggered then
color = draw.color(0, 255, 0, 255) -- Green when self triggered
elseif even_is_triggered then
color = draw.color(255, 255, 0, 255) -- Yellow when pair triggered
end
-- Draw filled glowing circles for odd-numbered waypoints
d:add_circle_filled(
screen_pos,
10,
color
)
d:add_circle(
screen_pos,
12,
draw.color(255, 255, 0, 100) -- Yellow glow
)
else
-- Even waypoint
local prev_odd_index = i - 1
local odd_is_triggered = prev_odd_index >= 1 and triggered_waypoints[prev_odd_index]

if is_triggered and odd_is_triggered then
-- Both waypoints triggered - green
color = draw.color(0, 255, 0, 255)
d:add_circle_filled(screen_pos, 10, color)
elseif is_triggered then
-- Self triggered - green
color = draw.color(0, 255, 0, 255)
d:add_circle_filled(screen_pos, 10, color)
elseif odd_is_triggered then
-- Only odd waypoint triggered - yellow
color = draw.color(255, 255, 0, 255)
d:add_circle_filled(screen_pos, 10, color)
else
-- No triggers - white outline
d:add_circle(screen_pos, 10, draw.color(255, 255, 255, 255))
end
end
end
::continue::
end
end
-- Register callbacks
events.present_queue:add(function()
check_controls()
on_draw()
end)
print("Script Loaded (Waypoint)")
print("Use checkboxes in menu (Lua > Elements) to control waypoints")