script = {}

script.name = "sentimental"
script.build = "dev"

script.color = {}
script.color.r = 175
script.color.g = 255
script.color.b = 255

script.conditions = {
  "+ global +",
  "+ standing +",
  "+ walking +",
  "+ running +",
  "+ crouching +",
  "+ ducking +",
  "+ aerobic +",
  "+ c-aerobic +"
}

script.clantag = {
  "",
  "❖",
  "s",
  "s❖",
  "se",
  "se❖",
  "sen",
  "sen❖",
  "sent",
  "sent❖",
  "senti",
  "senti❖",
  "sentim",
  "sentim❖",
  "sentime",
  "sentime❖",
  "sentimen",
  "sentimen❖",
  "sentiment",
  "sentiment❖",
  "sentimenta",
  "sentimenta❖",
  "sentimental",
  "sentimental",
  "sentimental",
  "sentimenta❖",
  "sentimenta",
  "sentiment❖",
  "sentiment",
  "sentimen❖",
  "sentimen",
  "sentime❖",
  "sentime",
  "sentim❖",
  "sentim",
  "senti❖",
  "senti",
  "sent❖",
  "sent",
  "sen❖",
  "sen",
  "se❖",
  "se",
  "s❖",
  "s",
  "❖",
  "",
  "",
  ""
}

libraries = {}

libraries.vector = require("vector")

libraries.entity = require("gamesense/entity")

libraries.base64 = require("gamesense/base64")

libraries.weapons = require("gamesense/csgo_weapons")

libraries.clipboard = require("gamesense/clipboard")

external_database = {
  key = "sentimental tech external database :3"
}

data = database.read(external_database.key)

if not data then
  data = {configs = {}}

  database.write(external_database.key, data)
end

defer(
function()
  database.write(external_database.key, data)

  database.flush()
end
)

setmetatable(
external_database,
{
  __index = data,
  __call = function(self, flush)
  database.write(external_database.key, data)

  if flush == true then
    database.flush()
  end
end
}
)

internal_database = {}

internal_database.antiaimbot = {}

internal_database.antiaimbot.yaw = "- gamesense -"

internal_database.antiaimbot.yaw_degree = 0

internal_database.antiaimbot.yaw_left = 0

internal_database.antiaimbot.yaw_right = 0

internal_database.antiaimbot.yaw_delay = 1

internal_database.antiaimbot.yaw_modifier = "- none -"

internal_database.antiaimbot.yaw_modifier_offset = 0

internal_database.antiaimbot.body_yaw = "- none -"

internal_database.antiaimbot.body_yaw_degree = 0

internal_database.antiaimbot.defensive_aa = "- none -"

internal_database.antiaimbot.defensive_speed = 10

internal_database.antiaimbot.defensive_pitch = "- zero -"

internal_database.antiaimbot.defensive_pitch_degree = 0

internal_database.antiaimbot.defensive_yaw = "- spin -"

internal_database.antiaimbot.defensive_yaw_degree = 0

internal_database.antiaimbot.inverted = false

internal_database.antiaimbot.last_tickcount = 0

internal_database.antiaimbot.anti_backstab = false

internal_database.antiaimbot.warmup_aa = false

internal_database.antiaimbot.defensive_difference = 0

internal_database.antiaimbot.defensive_active = false

internal_database.antiaimbot.will_defensive = false

internal_database.antiaimbot.defensive_side = false

internal_database.antiaimbot.safe_head = false

internal_database.settings = {}

internal_database.settings.clantag = false

internal_database.settings.last_clantag = ""

software = {}

software.antiaimbot = {}

software.antiaimbot.angles = {}

software.antiaimbot.angles.enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled")

software.antiaimbot.angles.pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")}

software.antiaimbot.angles.yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")

software.antiaimbot.angles.yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")}

software.antiaimbot.angles.yaw_jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw Jitter")}

software.antiaimbot.angles.body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")}

software.antiaimbot.angles.freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")

software.antiaimbot.angles.edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")

software.antiaimbot.angles.freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")}

software.antiaimbot.angles.roll = ui.reference("AA", "Anti-aimbot angles", "Roll")

software.antiaimbot.fakelag = {}

software.antiaimbot.fakelag.enabled = {ui.reference("AA", "Fake lag", "Enabled")}

software.antiaimbot.fakelag.amount = ui.reference("AA", "Fake lag", "Amount")

software.antiaimbot.fakelag.variance = ui.reference("AA", "Fake lag", "Variance")

software.antiaimbot.fakelag.limit = ui.reference("AA", "Fake lag", "Limit")

software.antiaimbot.other = {}

software.antiaimbot.other.slow_motion = {ui.reference("AA", "Other", "Slow motion")}

software.antiaimbot.other.leg_movement = ui.reference("AA", "Other", "Leg movement")

software.antiaimbot.other.on_shot_antiaim = {ui.reference("AA", "Other", "On shot anti-aim")}

software.antiaimbot.other.fake_peek = {ui.reference("AA", "Other", "Fake peek")}

software.ragebot = {}

software.ragebot.aimbot = {}

software.ragebot.aimbot.double_tap = {ui.reference("Rage", "Aimbot", "Double Tap")}

utility = {}

utility.rgb_to_hex = function(r, g, b)
return string.format("%02x%02x%02x%02x", r, g, b, 255)
end

utility.normalize = function(x, min, max)
delta = max - min

while x < min do
x = x + delta
end

while x > max do
x = x - delta
end

return x
end

utility.normalize_yaw = function(x)
return utility.normalize(x, -180, 180)
end

utility.get_body_yaw = function(animation_state)
body_yaw = animation_state.eye_angles_y - animation_state.goal_feet_yaw

body_yaw = utility.normalize_yaw(body_yaw)

return body_yaw
end

utility.table_contains = function(table, value)
for i = 1, #table do
if table[i] == value then
return true
end
end

return false
end

menu = {}

menu.elements = {}
menu.sub_elements = {}

menu.elements.script_enabled =
ui.new_checkbox(
"AA",
"Fake lag",
"\a" ..
utility.rgb_to_hex(255, 255, 255) ..
"❖ " ..
string.sub(script.name, 0, 5) ..
"\a" ..
utility.rgb_to_hex(script.color.r, script.color.g, script.color.b) ..
string.sub(script.name, 6, 64) .. " ❖"
)

menu.sub_elements.tab_label = ui.new_label("AA", "Fake lag", " ")

menu.elements.script_tab =
ui.new_combobox(
"AA",
"Fake lag",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ select tab",
{"✦ anti aimbot ✦", " ⌛ settings ⌛"}
)

menu.sub_elements.category_label = ui.new_label("AA", "Fake lag", " ")

menu.elements.antiaimbot_category =
ui.new_combobox("AA", "Fake lag", "\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ select category", {"✝ builder ✝"})

menu.elements.antiaimbot_condition =
ui.new_combobox(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ select condition",
script.conditions
)

menu.sub_elements.condition_label = ui.new_label("AA", "Anti-aimbot angles", " ")

menu.elements.settings_category =
ui.new_combobox(
"AA",
"Fake lag",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ select category",
{"✎ global ✎", "☸ configs ☸"}
)

menu.elements.settings_tweaks =
ui.new_multiselect(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ select tweaks",
{"- fast ladder -", "- anti backstab -", "- warmup aa -"}
)

menu.elements.settings_safe_head =
ui.new_multiselect(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ select safe head",
{"- on melee -", "- high ground -"}
)

menu.elements.settings_hitlogs =
ui.new_multiselect(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ select hitlogs",
{"- console -"}
)

menu.elements.settings_clantag =
ui.new_combobox(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ select clantag",
{"- none -", "- new -"}
)

menu.sub_elements.keybinds_label = ui.new_label("AA", "Fake lag", " ")

menu.sub_elements.antiaimbot_manual_left =
ui.new_hotkey("AA", "Fake lag", "\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ manual left")

menu.sub_elements.antiaimbot_manual_right =
ui.new_hotkey("AA", "Fake lag", "\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ manual right")

menu.sub_elements.antiaimbot_manual_reset =
ui.new_hotkey("AA", "Fake lag", "\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ manual reset")

menu.sub_elements.antiaimbot_freestanding =
ui.new_hotkey("AA", "Fake lag", "\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ freestanding")

menu.unique_builder_id = ""

for id = 1, #script.conditions do
menu.elements[script.conditions[id]] = {}

menu.unique_builder_id = menu.unique_builder_id .. " "

if script.conditions[id] ~= "+ global +" then
menu.elements[script.conditions[id]].override =
ui.new_checkbox(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "➛ override" .. menu.unique_builder_id
)
end

menu.elements[script.conditions[id]].yaw =
ui.new_combobox(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "↷ yaw ↷" .. menu.unique_builder_id,
{"- gamesense -", "- left & right -", "- delayed -"}
)

menu.elements[script.conditions[id]].yaw_degree =
ui.new_slider(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "↻ yaw degree ↻" .. menu.unique_builder_id,
-180,
180,
0,
true,
"°"
)

menu.elements[script.conditions[id]].yaw_left =
ui.new_slider(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "↻ yaw left ↻" .. menu.unique_builder_id,
-180,
180,
0,
true,
"°"
)

menu.elements[script.conditions[id]].yaw_right =
ui.new_slider(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "↻ yaw right ↻" .. menu.unique_builder_id,
-180,
180,
0,
true,
"°"
)

menu.elements[script.conditions[id]].yaw_delay =
ui.new_slider(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "⤡ yaw delay ⤡" .. menu.unique_builder_id,
1,
16,
1,
true,
"t"
)

menu.elements[script.conditions[id]].yaw_modifier =
ui.new_combobox(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "⤨ yaw modifier ⤨" .. menu.unique_builder_id,
{"- none -", "- offset -", "- center -", "random", "- skitter -"}
)

menu.elements[script.conditions[id]].yaw_modifier_offset =
ui.new_slider(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "⤿ yaw modifier offset ⤿" .. menu.unique_builder_id,
-180,
180,
0,
true,
"°"
)

menu.elements[script.conditions[id]].body_yaw =
ui.new_combobox(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "⤩ body yaw ⤩" .. menu.unique_builder_id,
{"- none -", "- custom -"}
)

menu.elements[script.conditions[id]].body_yaw_degree =
ui.new_slider(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "⤿ body yaw degree ⤿" .. menu.unique_builder_id,
-180,
180,
0,
true,
"°"
)

menu.elements[script.conditions[id]].defensive_aa =
ui.new_combobox(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "⇄ defensive aa ⇄" .. menu.unique_builder_id,
{"- none -", "- custom -"}
)

menu.elements[script.conditions[id]].defensive_speed =
ui.new_slider(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "⤫ defensive speed ⤫" .. menu.unique_builder_id,
1,
9,
4,
true,
"t"
)

menu.elements[script.conditions[id]].defensive_pitch =
ui.new_combobox(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "⤥ defensive pitch ⤥" .. menu.unique_builder_id,
{"- none -", "- random -", "- zero -", "- up -", "- up-switch -", "- custom -"}
)

menu.elements[script.conditions[id]].defensive_pitch_degree =
ui.new_slider(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "↻ defensive pitch degree ↻" .. menu.unique_builder_id,
-89,
89,
0,
true,
"°"
)

menu.elements[script.conditions[id]].defensive_yaw =
ui.new_combobox(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "⇵ defensive yaw ⇵" .. menu.unique_builder_id,
{"- none -", "- flick -", "- random -", "- spin -", "- custom -"}
)

menu.elements[script.conditions[id]].defensive_yaw_degree =
ui.new_slider(
"AA",
"Anti-aimbot angles",
"\a" .. utility.rgb_to_hex(255, 255, 255) .. "↻ defensive yaw degree ↻" .. menu.unique_builder_id,
-180,
180,
0,
true,
"°"
)
end

functions = {}

functions.hide_script_tab = function(value)
for category, _ in pairs(software.antiaimbot) do
for element, _ in pairs(software.antiaimbot[category]) do
if type(software.antiaimbot[category][element]) ~= "table" then
ui.set_visible(software.antiaimbot[category][element], not value)
else
for _, sub_element in pairs(software.antiaimbot[category][element]) do
ui.set_visible(sub_element, not value)
end
end
end
end
end

functions.element_visibility = function(element, value)
ui.set_visible(element, ui.get(menu.elements.script_enabled) and value)
end

functions.menu_setup = function()
functions.hide_script_tab(ui.get(menu.elements.script_enabled))

functions.element_visibility(menu.elements.script_tab, true)

functions.element_visibility(
menu.elements.antiaimbot_category,
ui.get(menu.elements.script_tab) == "✦ anti aimbot ✦"
)

functions.element_visibility(menu.elements.settings_category, ui.get(menu.elements.script_tab) == " ⌛ settings ⌛")

functions.element_visibility(
  menu.elements.antiaimbot_condition,
  ui.get(menu.elements.script_tab) == "✦ anti aimbot ✦" and
  ui.get(menu.elements.antiaimbot_category) == "✝ builder ✝"
  )

  functions.element_visibility(
    menu.sub_elements.condition_label,
    ui.get(menu.elements.script_tab) == "✦ anti aimbot ✦" and
    ui.get(menu.elements.antiaimbot_category) == "✝ builder ✝"
    )

    functions.element_visibility(
      menu.sub_elements.antiaimbot_manual_left,
      ui.get(menu.elements.script_tab) == "✦ anti aimbot ✦" and
      ui.get(menu.elements.antiaimbot_category) == "✝ builder ✝"
      )

      functions.element_visibility(
        menu.sub_elements.antiaimbot_manual_right,
        ui.get(menu.elements.script_tab) == "✦ anti aimbot ✦" and
        ui.get(menu.elements.antiaimbot_category) == "✝ builder ✝"
        )

        functions.element_visibility(
          menu.sub_elements.antiaimbot_manual_reset,
          ui.get(menu.elements.script_tab) == "✦ anti aimbot ✦" and
          ui.get(menu.elements.antiaimbot_category) == "✝ builder ✝"
          )

          functions.element_visibility(
            menu.sub_elements.antiaimbot_freestanding,
            ui.get(menu.elements.script_tab) == "✦ anti aimbot ✦" and
            ui.get(menu.elements.antiaimbot_category) == "✝ builder ✝"
            )

            functions.element_visibility(
              menu.sub_elements.keybinds_label,
              ui.get(menu.elements.script_tab) == "✦ anti aimbot ✦" and
              ui.get(menu.elements.antiaimbot_category) == "✝ builder ✝"
              )

              functions.element_visibility(
                menu.elements.settings_tweaks,
                ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "✎ global ✎"
                )

                functions.element_visibility(
                  menu.elements.settings_safe_head,
                  ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "✎ global ✎"
                  )

                  functions.element_visibility(
                    menu.elements.settings_hitlogs,
                    ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "✎ global ✎"
                    )

                    functions.element_visibility(
                      menu.elements.settings_clantag,
                      ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "✎ global ✎"
                      )

                      functions.element_visibility(
                        menu.sub_elements.settings_list_config,
                        ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "☸ configs ☸"
                        )

                        functions.element_visibility(
                          menu.sub_elements.settings_name_config,
                          ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "☸ configs ☸"
                          )

                          functions.element_visibility(
                            menu.sub_elements.settings_save_config,
                            ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "☸ configs ☸"
                            )

                            functions.element_visibility(
                              menu.sub_elements.settings_load_config,
                              ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "☸ configs ☸"
                              )

                              functions.element_visibility(
                                menu.sub_elements.settings_delete_config,
                                ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "☸ configs ☸"
                                )

                                functions.element_visibility(
                                  menu.sub_elements.settings_import_config,
                                  ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "☸ configs ☸"
                                  )

                                  functions.element_visibility(
                                    menu.sub_elements.settings_export_config,
                                    ui.get(menu.elements.script_tab) == " ⌛ settings ⌛" and ui.get(menu.elements.settings_category) == "☸ configs ☸"
                                    )

                                    conditions = {}

                                    conditions.builder =
                                    (ui.get(menu.elements.script_tab) == "✦ anti aimbot ✦" and
                                    ui.get(menu.elements.antiaimbot_category) == "✝ builder ✝") and
                                    true or
                                    false

                                    for id = 1, #script.conditions do
                                      if script.conditions[id] ~= "+ global +" then
                                        functions.element_visibility(
                                          menu.elements[script.conditions[id]].override,
                                          ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder
                                          )
                                        end

                                        functions.element_visibility(
                                          menu.elements[script.conditions[id]].yaw,
                                          ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder and
                                          ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                          script.conditions[id] == "+ global +")
                                          )

                                          functions.element_visibility(
                                            menu.elements[script.conditions[id]].yaw_degree,
                                            ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and
                                            ui.get(menu.elements[script.conditions[id]].yaw) == "- gamesense -" and
                                            conditions.builder and
                                            ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                            script.conditions[id] == "+ global +")
                                            )

                                            functions.element_visibility(
                                              menu.elements[script.conditions[id]].yaw_left,
                                              ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and
                                              ui.get(menu.elements[script.conditions[id]].yaw) ~= "- gamesense -" and
                                              conditions.builder and
                                              ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                              script.conditions[id] == "+ global +")
                                              )

                                              functions.element_visibility(
                                                menu.elements[script.conditions[id]].yaw_right,
                                                ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and
                                                ui.get(menu.elements[script.conditions[id]].yaw) ~= "- gamesense -" and
                                                conditions.builder and
                                                ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                script.conditions[id] == "+ global +")
                                                )

                                                functions.element_visibility(
                                                  menu.elements[script.conditions[id]].yaw_delay,
                                                  ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and
                                                  ui.get(menu.elements[script.conditions[id]].yaw) == "- delayed -" and
                                                  conditions.builder and
                                                  ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                  script.conditions[id] == "+ global +")
                                                  )

                                                  functions.element_visibility(
                                                    menu.elements[script.conditions[id]].yaw_modifier,
                                                    ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder and
                                                    ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                    script.conditions[id] == "+ global +")
                                                    )

                                                    functions.element_visibility(
                                                      menu.elements[script.conditions[id]].yaw_modifier_offset,
                                                      ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and
                                                      ui.get(menu.elements[script.conditions[id]].yaw_modifier) ~= "- none -" and
                                                      conditions.builder and
                                                      ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                      script.conditions[id] == "+ global +")
                                                      )

                                                      functions.element_visibility(
                                                        menu.elements[script.conditions[id]].body_yaw,
                                                        ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder and
                                                        ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                        script.conditions[id] == "+ global +")
                                                        )

                                                        functions.element_visibility(
                                                          menu.elements[script.conditions[id]].body_yaw_degree,
                                                          ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and
                                                          ui.get(menu.elements[script.conditions[id]].body_yaw) ~= "- none -" and
                                                          conditions.builder and
                                                          ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                          script.conditions[id] == "+ global +")
                                                          )

                                                          functions.element_visibility(
                                                            menu.elements[script.conditions[id]].defensive_aa,
                                                            ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder and
                                                            ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                            script.conditions[id] == "+ global +")
                                                            )

                                                            functions.element_visibility(
                                                              menu.elements[script.conditions[id]].defensive_speed,
                                                              ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder and
                                                              ui.get(menu.elements[script.conditions[id]].defensive_aa) ~= "- none -" and
                                                              ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                              script.conditions[id] == "+ global +")
                                                              )

                                                              functions.element_visibility(
                                                                menu.elements[script.conditions[id]].defensive_pitch,
                                                                ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder and
                                                                ui.get(menu.elements[script.conditions[id]].defensive_aa) ~= "- none -" and
                                                                ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                                script.conditions[id] == "+ global +")
                                                                )

                                                                functions.element_visibility(
                                                                  menu.elements[script.conditions[id]].defensive_pitch_degree,
                                                                  ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder and
                                                                  ui.get(menu.elements[script.conditions[id]].defensive_aa) ~= "- none -" and
                                                                  ui.get(menu.elements[script.conditions[id]].defensive_pitch) == "- custom -" and
                                                                  ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                                  script.conditions[id] == "+ global +")
                                                                  )

                                                                  functions.element_visibility(
                                                                    menu.elements[script.conditions[id]].defensive_yaw,
                                                                    ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder and
                                                                    ui.get(menu.elements[script.conditions[id]].defensive_aa) ~= "- none -" and
                                                                    ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                                    script.conditions[id] == "+ global +")
                                                                    )

                                                                    functions.element_visibility(
                                                                      menu.elements[script.conditions[id]].defensive_yaw_degree,
                                                                      ui.get(menu.elements.antiaimbot_condition) == script.conditions[id] and conditions.builder and
                                                                      ui.get(menu.elements[script.conditions[id]].defensive_aa) ~= "- none -" and
                                                                      ui.get(menu.elements[script.conditions[id]].defensive_yaw) ~= "- none -" and
                                                                      ((script.conditions[id] ~= "+ global +" and ui.get(menu.elements[script.conditions[id]].override)) or
                                                                      script.conditions[id] == "+ global +")
                                                                      )
                                                                    end
                                                                  end

                                                                  functions.get_condition = function(player)
                                                                    if not player or not entity.is_alive(player) then
                                                                      return "+ dead +"
                                                                    end

                                                                    if not libraries.entity(player) or not libraries.entity.get_anim_state(libraries.entity(player)) then
                                                                      return "+ dead +"
                                                                    end

                                                                    condition_data = {}

                                                                    condition_data.player = libraries.entity(player)

                                                                    condition_data.animation_state = libraries.entity.get_anim_state(condition_data.player)

                                                                    condition_data.choked = globals.chokedcommands() ~= 0

                                                                    condition_data.flags = entity.get_prop(player, "m_fFlags")

                                                                    condition_data.velocity = condition_data.animation_state.m_velocity

                                                                    condition_data.on_ground = condition_data.animation_state.on_ground

                                                                    condition_data.on_crouch = entity.get_prop(player, "m_flDuckAmount") > 0.1

                                                                    condition_data.slow_motion =
                                                                    (ui.get(software.antiaimbot.other.slow_motion[1]) and ui.get(software.antiaimbot.other.slow_motion[2])) and true or
                                                                    false

                                                                    if condition_data.velocity <= 3 and not condition_data.on_crouch then
                                                                      return (ui.get(menu.elements["+ standing +"].override) and "+ standing +" or "+ global +")
                                                                    elseif condition_data.velocity <= 3 and condition_data.on_crouch then
                                                                      return (ui.get(menu.elements["+ crouching +"].override) and "+ crouching +" or "+ global +")
                                                                    elseif
                                                                      condition_data.velocity > 3 and not condition_data.on_crouch and condition_data.on_ground and
                                                                      not condition_data.slow_motion
                                                                      then
                                                                        return (ui.get(menu.elements["+ running +"].override) and "+ running +" or "+ global +")
                                                                      elseif
                                                                        condition_data.velocity > 3 and not condition_data.on_crouch and condition_data.on_ground and
                                                                        condition_data.slow_motion
                                                                        then
                                                                          return (ui.get(menu.elements["+ walking +"].override) and "+ walking +" or "+ global +")
                                                                        elseif condition_data.velocity > 3 and condition_data.on_crouch and condition_data.on_ground then
                                                                          return (ui.get(menu.elements["+ ducking +"].override) and "+ ducking +" or "+ global +")
                                                                        elseif not condition_data.on_crouch and not condition_data.on_ground then
                                                                          return (ui.get(menu.elements["+ aerobic +"].override) and "+ aerobic +" or "+ global +")
                                                                        elseif condition_data.on_crouch and not condition_data.on_ground then
                                                                          return (ui.get(menu.elements["+ c-aerobic +"].override) and "+ c-aerobic +" or "+ global +")
                                                                        end
                                                                      end

                                                                      functions.update_database = function()
                                                                        player = entity.get_local_player()

                                                                        if not player or not entity.is_alive(player) then
                                                                          return
                                                                        end

                                                                        condition = functions.get_condition(player)

                                                                        if not condition or condition == "+ dead +" then
                                                                          return
                                                                        end

                                                                        for id = 1, #script.conditions do
                                                                          if condition == script.conditions[id] then
                                                                            for key, value in pairs(menu.elements[script.conditions[id]]) do
                                                                              internal_database.antiaimbot[key] = ui.get(value)
                                                                            end
                                                                          end
                                                                        end
                                                                      end

                                                                      utility.manual_time, utility.manual_side, utility.last_manual_side, utility.can_press = 0, 0, 0, true

                                                                      functions.get_manual = function()
                                                                        utility.can_press = utility.manual_time + 0.2 < globals.realtime()

                                                                        if ui.get(menu.sub_elements.antiaimbot_manual_left) and utility.can_press then
                                                                          utility.manual_side = 1

                                                                          if utility.last_manual_side == utility.manual_side then
                                                                            utility.manual_side = 0
                                                                          end

                                                                          utility.manual_time = globals.realtime()
                                                                        end

                                                                        if ui.get(menu.sub_elements.antiaimbot_manual_right) and utility.can_press then
                                                                          utility.manual_side = 2

                                                                          if utility.last_manual_side == utility.manual_side then
                                                                            utility.manual_side = 0
                                                                          end

                                                                          utility.manual_time = globals.realtime()
                                                                        end

                                                                        if ui.get(menu.sub_elements.antiaimbot_manual_reset) and utility.can_press then
                                                                          utility.manual_side = 0

                                                                          utility.manual_time = globals.realtime()
                                                                        end

                                                                        utility.last_manual_side = utility.manual_side

                                                                        if utility.manual_side == 1 then
                                                                          return 1
                                                                        end
                                                                        if utility.manual_side == 2 then
                                                                          return 2
                                                                        end
                                                                        if utility.manual_side == 0 then
                                                                          return 0
                                                                        end
                                                                      end
                                                                      functions.update_antiaimbot = function(cmd)
                                                                        player = entity.get_local_player()
                                                                        if not player or not entity.is_alive(player) then
                                                                          return
                                                                        end
                                                                        if not ui.get(menu.elements.script_enabled) then
                                                                          return
                                                                        end
                                                                        if globals.chokedcommands() == 0 then
                                                                          if internal_database.antiaimbot.yaw ~= "- delayed -" then
                                                                            internal_database.antiaimbot.inverted =
                                                                            utility.get_body_yaw(libraries.entity.get_anim_state(libraries.entity(player))) > 0 and true or false
                                                                          else
                                                                            if
                                                                            globals.tickcount() >
                                                                            internal_database.antiaimbot.last_tickcount + internal_database.antiaimbot.yaw_delay
                                                                            then
                                                                              internal_database.antiaimbot.inverted = not internal_database.antiaimbot.inverted
                                                                              internal_database.antiaimbot.last_tickcount = globals.tickcount()
                                                                            elseif globals.tickcount() < internal_database.antiaimbot.last_tickcount then
                                                                              internal_database.antiaimbot.last_tickcount = globals.tickcount()
                                                                            end
                                                                          end
                                                                        end
                                                                        weapon_data = libraries.weapons(entity.get_player_weapon(player))
                                                                        player_melee = weapon_data and weapon_data.weapon_type_int == 0
                                                                        if
                                                                        not player_melee and internal_database.antiaimbot.defensive_aa == "- custom -" and
                                                                        internal_database.antiaimbot.defensive_active and
                                                                        ((ui.get(software.antiaimbot.other.on_shot_antiaim[1]) and
                                                                        ui.get(software.antiaimbot.other.on_shot_antiaim[2])) or
                                                                        (ui.get(software.ragebot.aimbot.double_tap[1]) and ui.get(software.ragebot.aimbot.double_tap[2])))
                                                                        then
                                                                          internal_database.antiaimbot.will_defensive = true
                                                                        else
                                                                          internal_database.antiaimbot.will_defensive = false
                                                                        end
                                                                        condition_data = {}
                                                                        condition_data.yaw_base = "At targets"
                                                                        condition_data.pitch = "Down"
                                                                        condition_data.pitch_value = 0
                                                                        condition_data.yaw = "180"
                                                                        condition_data.yaw_value = 0
                                                                        condition_data.yaw_jitter = "Off"
                                                                        condition_data.yaw_jitter_value = 0
                                                                        condition_data.body_yaw = "Off"
                                                                        condition_data.body_yaw_value = 0
                                                                        if internal_database.antiaimbot.anti_backstab then
                                                                          condition_data.yaw_base = "At targets"
                                                                          condition_data.pitch = "Down"
                                                                          condition_data.yaw = "180"
                                                                          condition_data.yaw_value = utility.normalize_yaw(180)
                                                                          condition_data.yaw_jitter = "Off"
                                                                        else
                                                                          if internal_database.antiaimbot.safe_head then
                                                                            condition_data.yaw_base = "At targets"
                                                                            condition_data.pitch = "Down"
                                                                            condition_data.yaw = "180"
                                                                            condition_data.yaw_value = utility.normalize_yaw(0)
                                                                            condition_data.yaw_jitter = "Off"
                                                                          else
                                                                            if functions.get_manual() ~= 0 then
                                                                              condition_data.yaw_base = "Local view"
                                                                              condition_data.pitch = "Down"
                                                                              condition_data.yaw = "180"
                                                                              condition_data.yaw_value =
                                                                              functions.get_manual() ~= 2 and utility.normalize_yaw(-90) or utility.normalize_yaw(90)
                                                                                condition_data.yaw_jitter = "Off"
                                                                              else
                                                                                condition_data.yaw_base = "At targets"
                                                                                condition_data.yaw_jitter_value =
                                                                                utility.normalize_yaw(internal_database.antiaimbot.yaw_modifier_offset)
                                                                                if internal_database.antiaimbot.will_defensive then
                                                                                  if
                                                                                  internal_database.antiaimbot.defensive_pitch == "- zero -" or
                                                                                  internal_database.antiaimbot.defensive_pitch == "- up-switch -" or
                                                                                  internal_database.antiaimbot.defensive_pitch == "- custom -" or
                                                                                  internal_database.antiaimbot.defensive_pitch == "- random -"
                                                                                  then
                                                                                    condition_data.pitch = "Custom"
                                                                                    if internal_database.antiaimbot.defensive_pitch == "- zero -" then
                                                                                      condition_data.pitch_value = 0
                                                                                    elseif internal_database.antiaimbot.defensive_pitch == "- up-switch -" then
                                                                                      condition_data.pitch_value = client.random_int(-45, -65)
                                                                                    elseif internal_database.antiaimbot.defensive_pitch == "- custom -" then
                                                                                      condition_data.pitch_value = internal_database.antiaimbot.defensive_pitch_degree
                                                                                    elseif internal_database.antiaimbot.defensive_pitch == "- random -" then
                                                                                      condition_data.pitch_value = client.random_int(-89, 89)
                                                                                    else
                                                                                      condition_data.pitch_value = 0
                                                                                    end
                                                                                  elseif internal_database.antiaimbot.defensive_pitch == "- up -" then
                                                                                    condition_data.pitch = "Up"
                                                                                  elseif internal_database.antiaimbot.defensive_pitch == "- none -" then
                                                                                    condition_data.pitch = "Down"
                                                                                  end
                                                                                  if internal_database.antiaimbot.defensive_yaw == "- spin -" then
                                                                                    condition_data.yaw = "Spin"
                                                                                  else
                                                                                    condition_data.yaw = "180"
                                                                                  end
                                                                                  if
                                                                                  internal_database.antiaimbot.defensive_yaw == "- spin -" or
                                                                                  internal_database.antiaimbot.defensive_yaw == "- custom -"
                                                                                  then
                                                                                    condition_data.yaw_value =
                                                                                    utility.normalize_yaw(internal_database.antiaimbot.defensive_yaw_degree)
                                                                                    condition_data.yaw_jitter_value = 0
                                                                                    condition_data.yaw_jitter = "Off"
                                                                                  elseif internal_database.antiaimbot.defensive_yaw == "- random -" then
                                                                                    condition_data.yaw_value = utility.normalize_yaw(client.random_int(-180, 180))
                                                                                    condition_data.yaw_jitter_value = 0
                                                                                    condition_data.yaw_jitter = "Off"
                                                                                  elseif internal_database.antiaimbot.defensive_yaw == "- flick -" then
                                                                                    condition_data.yaw_value =
                                                                                    utility.normalize_yaw(
                                                                                    internal_database.antiaimbot.defensive_side and
                                                                                    -internal_database.antiaimbot.defensive_yaw_degree or
                                                                                    internal_database.antiaimbot.defensive_yaw_degree
                                                                                    )
                                                                                    condition_data.yaw_jitter_value = 0
                                                                                    condition_data.yaw_jitter = "Off"
                                                                                  else
                                                                                    if internal_database.antiaimbot.yaw == "- gamesense -" then
                                                                                      condition_data.yaw_value = utility.normalize_yaw(internal_database.antiaimbot.yaw_degree)
                                                                                    else
                                                                                      condition_data.yaw_value =
                                                                                      utility.normalize_yaw(
                                                                                      internal_database.antiaimbot.inverted and internal_database.antiaimbot.yaw_left or
                                                                                      internal_database.antiaimbot.yaw_right
                                                                                      )
                                                                                    end
                                                                                    if internal_database.antiaimbot.yaw_modifier == "- none -" then
                                                                                      condition_data.yaw_jitter_value = 0
                                                                                      condition_data.yaw_jitter = "Off"
                                                                                    elseif internal_database.antiaimbot.yaw_modifier == "- offset -" then
                                                                                      condition_data.yaw_jitter_value =
                                                                                      utility.normalize_yaw(internal_database.antiaimbot.yaw_modifier_offset)
                                                                                      condition_data.yaw_jitter = "Offset"
                                                                                    elseif internal_database.antiaimbot.yaw_modifier == "- random -" then
                                                                                      condition_data.yaw_jitter_value =
                                                                                      utility.normalize_yaw(internal_database.antiaimbot.yaw_modifier_offset)
                                                                                      condition_data.yaw_jitter = "Random"
                                                                                    elseif internal_database.antiaimbot.yaw_modifier == "- center -" then
                                                                                      condition_data.yaw_jitter_value =
                                                                                      utility.normalize_yaw(internal_database.antiaimbot.yaw_modifier_offset)
                                                                                      condition_data.yaw_jitter = "Center"
                                                                                    elseif internal_database.antiaimbot.yaw_modifier == "- skitter -" then
                                                                                      condition_data.yaw_jitter_value =
                                                                                      utility.normalize_yaw(internal_database.antiaimbot.yaw_modifier_offset)
                                                                                      condition_data.yaw_jitter = "Skitter"
                                                                                    end
                                                                                  end
                                                                                else
                                                                                  condition_data.pitch = "Down"
                                                                                  condition_data.yaw = "180"
                                                                                  if internal_database.antiaimbot.yaw == "- gamesense -" then
                                                                                    condition_data.yaw_value = utility.normalize_yaw(internal_database.antiaimbot.yaw_degree)
                                                                                  else
                                                                                    condition_data.yaw_value =
                                                                                    utility.normalize_yaw(
                                                                                    internal_database.antiaimbot.inverted and internal_database.antiaimbot.yaw_left or
                                                                                    internal_database.antiaimbot.yaw_right
                                                                                    )
                                                                                  end
                                                                                  if internal_database.antiaimbot.yaw_modifier == "- none -" then
                                                                                    condition_data.yaw_jitter_value = 0
                                                                                    condition_data.yaw_jitter = "Off"
                                                                                  elseif internal_database.antiaimbot.yaw_modifier == "- offset -" then
                                                                                    condition_data.yaw_jitter_value =
                                                                                    utility.normalize_yaw(internal_database.antiaimbot.yaw_modifier_offset)
                                                                                    condition_data.yaw_jitter = "Offset"
                                                                                  elseif internal_database.antiaimbot.yaw_modifier == "- random -" then
                                                                                    condition_data.yaw_jitter_value =
                                                                                    utility.normalize_yaw(internal_database.antiaimbot.yaw_modifier_offset)
                                                                                    condition_data.yaw_jitter = "Random"
                                                                                  elseif internal_database.antiaimbot.yaw_modifier == "- center -" then
                                                                                    condition_data.yaw_jitter_value =
                                                                                    utility.normalize_yaw(internal_database.antiaimbot.yaw_modifier_offset)
                                                                                    condition_data.yaw_jitter = "Center"
                                                                                  elseif internal_database.antiaimbot.yaw_modifier == "- skitter -" then
                                                                                    condition_data.yaw_jitter_value =
                                                                                    utility.normalize_yaw(internal_database.antiaimbot.yaw_modifier_offset)
                                                                                    condition_data.yaw_jitter = "Skitter"
                                                                                  end
                                                                                end
                                                                                if
                                                                                internal_database.antiaimbot.body_yaw ~= "- none -" or
                                                                                internal_database.antiaimbot.yaw == "- left & right -"
                                                                                then
                                                                                  if internal_database.antiaimbot.yaw == "- left & right -" then
                                                                                    condition_data.body_yaw_value =
                                                                                    utility.normalize_yaw(
                                                                                    internal_database.antiaimbot.inverted and internal_database.antiaimbot.body_yaw_degree or
                                                                                    -internal_database.antiaimbot.body_yaw_degree
                                                                                    )
                                                                                    condition_data.body_yaw = "Jitter"
                                                                                  elseif internal_database.antiaimbot.yaw == "- delayed -" then
                                                                                    condition_data.body_yaw_value =
                                                                                    internal_database.antiaimbot.inverted and utility.normalize_yaw(-1) or
                                                                                    utility.normalize_yaw(1)
                                                                                    condition_data.body_yaw = "Static"
                                                                                  else
                                                                                    condition_data.body_yaw_value =
                                                                                    utility.normalize_yaw(internal_database.antiaimbot.body_yaw_degree)
                                                                                    condition_data.body_yaw = "Jitter"
                                                                                  end
                                                                                else
                                                                                  condition_data.body_yaw_value = utility.normalize_yaw(0)
                                                                                  condition_data.body_yaw = "Off"
                                                                                end
                                                                              end
                                                                            end
                                                                          end
                                                                          ui.set(menu.sub_elements.antiaimbot_manual_left, "On hotkey")
                                                                          ui.set(menu.sub_elements.antiaimbot_manual_right, "On hotkey")
                                                                          ui.set(menu.sub_elements.antiaimbot_manual_reset, "On hotkey")
                                                                          ui.set(software.antiaimbot.angles.enabled, not internal_database.antiaimbot.warmup_aa)
                                                                          ui.set(software.antiaimbot.angles.yaw_base, condition_data.yaw_base)
                                                                          ui.set(software.antiaimbot.angles.pitch[1], condition_data.pitch)
                                                                          ui.set(software.antiaimbot.angles.pitch[2], condition_data.pitch_value)
                                                                          ui.set(software.antiaimbot.angles.yaw[1], condition_data.yaw)
                                                                          ui.set(software.antiaimbot.angles.yaw[2], condition_data.yaw_value)
                                                                          ui.set(software.antiaimbot.angles.yaw_jitter[1], condition_data.yaw_jitter)
                                                                          ui.set(software.antiaimbot.angles.yaw_jitter[2], condition_data.yaw_jitter_value)
                                                                          ui.set(software.antiaimbot.angles.body_yaw[1], condition_data.body_yaw)
                                                                          ui.set(software.antiaimbot.angles.body_yaw[2], condition_data.body_yaw_value)
                                                                          ui.set(software.antiaimbot.angles.freestanding[1], ui.get(menu.sub_elements.antiaimbot_freestanding))
                                                                          ui.set(software.antiaimbot.angles.freestanding[2], "Always on")
                                                                          ui.set(software.antiaimbot.angles.freestanding_body_yaw, false)
                                                                          ui.set(software.antiaimbot.angles.edge_yaw, false)
                                                                          ui.set(software.antiaimbot.angles.roll, 0)
                                                                        end
                                                                        functions.watermark = function()
                                                                          screen_x, screen_y = client.screen_size()
                                                                          text =
                                                                          not internal_database.antiaimbot.inverted and
                                                                          "\a" ..
                                                                          utility.rgb_to_hex(255, 255, 255) ..
                                                                          "❖ " ..
                                                                          "s e n t i m e n t a l . " ..
                                                                          "\a" ..
                                                                          utility.rgb_to_hex(script.color.r, script.color.g, script.color.b) ..
                                                                          "t e c h n o l o g i e s" .. " ❖" or
                                                                          "\a" ..
                                                                          utility.rgb_to_hex(script.color.r, script.color.g, script.color.b) ..
                                                                          "❖ " ..
                                                                          "s e n t i m e n t a l " ..
                                                                          "\a" .. utility.rgb_to_hex(255, 255, 255) .. ". t e c h n o l o g i e s" .. " ❖"
                                                                          renderer.text(screen_x / 2, screen_y - 12, 255, 255, 255, 255, "c", 0, text)
                                                                        end
                                                                        functions.fast_ladder = function(cmd)
                                                                          player = entity.get_local_player()
                                                                          if not player or not entity.is_alive(player) then
                                                                            return
                                                                          end
                                                                          if utility.table_contains(ui.get(menu.elements.settings_tweaks), "- fast ladder -") then
                                                                            pitch, yaw = client.camera_angles()
                                                                            if entity.get_prop(player, "m_MoveType") == 9 then
                                                                              cmd.in_moveleft = (cmd.forwardmove < 0 or pitch > 45) and 1 or 0
                                                                              cmd.in_moveright = not (cmd.forwardmove < 0 or pitch > 45) and 1 or 0
                                                                              cmd.in_forward = (cmd.forwardmove < 0 or pitch > 45) and 1 or 0
                                                                              cmd.in_back = not (cmd.forwardmove < 0 or pitch > 45) and 1 or 0
                                                                              cmd.pitch = 89
                                                                              cmd.yaw = utility.normalize_yaw(cmd.yaw + 90)
                                                                            end
                                                                          end
                                                                        end
                                                                        functions.anti_backstab = function(cmd)
                                                                          player = entity.get_local_player()
                                                                          if not player or not entity.is_alive(player) then
                                                                            internal_database.antiaimbot.anti_backstab = false
                                                                            return
                                                                          end
                                                                          eye_x, eye_y, eye_z = client.eye_position()
                                                                          enemies = entity.get_players(true)
                                                                          if utility.table_contains(ui.get(menu.elements.settings_tweaks), "- anti backstab -") then
                                                                            if enemies ~= nil then
                                                                              for i, enemy in pairs(enemies) do
                                                                                for h = 0, 18 do
                                                                                  head_x, head_y, head_z = entity.hitbox_position(enemies[i], h)
                                                                                  fractions, index_hit = client.trace_line(player, eye_x, eye_y, eye_z, head_x, head_y, head_z)
                                                                                  if
                                                                                  250 >=
                                                                                  libraries.vector(entity.get_prop(enemy, "m_vecOrigin")):dist(
                                                                                  libraries.vector(entity.get_prop(player, "m_vecOrigin"))
                                                                                  ) and
                                                                                  entity.is_alive(enemy) and
                                                                                  entity.get_player_weapon(enemy) ~= nil and
                                                                                  entity.get_classname(entity.get_player_weapon(enemy)) == "CKnife" and
                                                                                  (index_hit == enemies[i] or fractions == 1) and
                                                                                  not entity.is_dormant(enemies[i])
                                                                                  then
                                                                                    internal_database.antiaimbot.anti_backstab = true
                                                                                  else
                                                                                    internal_database.antiaimbot.anti_backstab = false
                                                                                  end
                                                                                end
                                                                              end
                                                                            end
                                                                          else
                                                                            internal_database.antiaimbot.anti_backstab = false
                                                                          end
                                                                        end
                                                                        functions.warmup_aa = function(cmd)
                                                                          player = entity.get_local_player()
                                                                          if not player or not entity.is_alive(player) then
                                                                            internal_database.antiaimbot.warmup_aa = false
                                                                            return
                                                                          end
                                                                          if
                                                                          entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") >= 1 and
                                                                          utility.table_contains(ui.get(menu.elements.settings_tweaks), "- warmup aa -")
                                                                          then
                                                                            internal_database.antiaimbot.warmup_aa = true
                                                                          else
                                                                            internal_database.antiaimbot.warmup_aa = false
                                                                          end
                                                                        end
                                                                        functions.safe_head = function(cmd)
                                                                          player = entity.get_local_player()
                                                                          if not player or not entity.is_alive(player) then
                                                                            internal_database.antiaimbot.safe_head = false
                                                                            return
                                                                          end
                                                                          condition = functions.get_condition(player)
                                                                          if not condition then
                                                                            return
                                                                          end
                                                                          if
                                                                          utility.table_contains(ui.get(menu.elements.settings_safe_head), "- on melee -") or
                                                                          utility.table_contains(ui.get(menu.elements.settings_safe_head), "- high ground -")
                                                                          then
                                                                            weapon_data = libraries.weapons(entity.get_player_weapon(player))
                                                                            player_melee = weapon_data and weapon_data.weapon_type_int == 0
                                                                            if client.current_threat() ~= nil then
                                                                              eyes_x, eyes_y, eyes_z = client.eye_position()
                                                                              if not entity.get_origin(client.current_threat()) then
                                                                                internal_database.antiaimbot.safe_head = false
                                                                                return
                                                                              end
                                                                              enemy_origin = libraries.vector(entity.get_origin(client.current_threat()))
                                                                              trace, trace_entity =
                                                                              client.trace_line(player, eyes_x, eyes_y, eyes_z, enemy_origin.x, enemy_origin.y, enemy_origin.z + 56)
                                                                              enemy_height = libraries.vector(entity.get_origin(player)).z - enemy_origin.z
                                                                              enemy_distance = libraries.vector(entity.get_origin(player)):dist(enemy_origin)
                                                                              enemy_visible = trace_entity == client.current_threat()
                                                                              if
                                                                              (utility.table_contains(ui.get(menu.elements.settings_safe_head), "- on melee -") and
                                                                              (condition == "+ aerobic +" or condition == "+ c-aerobic +") and
                                                                              player_melee and
                                                                              enemy_height > -32) or
                                                                              (utility.table_contains(ui.get(menu.elements.settings_safe_head), "- high ground -") and
                                                                              enemy_height > 64 and
                                                                              (enemy_visible or enemy_distance < 1024))
                                                                              then
                                                                                internal_database.antiaimbot.safe_head = true
                                                                              else
                                                                                internal_database.antiaimbot.safe_head = false
                                                                              end
                                                                            end
                                                                          else
                                                                            internal_database.antiaimbot.safe_head = false
                                                                          end
                                                                        end
                                                                        functions.tweaks = function(cmd)
                                                                          functions.anti_backstab(cmd)
                                                                            functions.fast_ladder(cmd)
                                                                              functions.warmup_aa(cmd)
                                                                                functions.safe_head(cmd)
                                                                                end
                                                                                max_tickbase, last_command = 0, 0
                                                                                functions.update_defensive_ticks = function(cmd)
                                                                                  player = entity.get_local_player()
                                                                                  if not player or not entity.is_alive(player) then
                                                                                    return
                                                                                  end
                                                                                  if last_command ~= cmd.command_number then
                                                                                    return
                                                                                  end
                                                                                  tickbase = entity.get_prop(player, "m_nTickBase") or 0
                                                                                  if max_tickbase ~= nil then
                                                                                    internal_database.antiaimbot.defensive_difference = tickbase - max_tickbase
                                                                                    internal_database.antiaimbot.defensive_active =
                                                                                    internal_database.antiaimbot.defensive_difference < (-internal_database.antiaimbot.defensive_speed - 3)
                                                                                    internal_database.antiaimbot.defensive_side = not internal_database.antiaimbot.defensive_side
                                                                                    if math.abs(tickbase - max_tickbase) > 64 then
                                                                                      max_tickbase = 0
                                                                                    end
                                                                                  end
                                                                                  max_tickbase = math.max(tickbase, max_tickbase or 0)
                                                                                end
                                                                                functions.update_force_defensive = function(cmd)
                                                                                  cmd.force_defensive = true
                                                                                end
                                                                                functions.update_last_command = function(cmd)
                                                                                  player = entity.get_local_player()
                                                                                  if not player or not entity.is_alive(player) then
                                                                                    return
                                                                                  end
                                                                                  last_command = cmd.command_number
                                                                                end
                                                                                hitboxes = {
                                                                                  "generic",
                                                                                  "head",
                                                                                  "chest",
                                                                                  "stomach",
                                                                                  "left arm",
                                                                                  "right arm",
                                                                                  "left leg",
                                                                                  "right leg",
                                                                                  "neck",
                                                                                  "unknown",
                                                                                  "gear"
                                                                                }
                                                                                functions.on_hit = function(player)
                                                                                  hitbox = hitboxes[player.hitgroup + 1] or "unknown"
                                                                                  hit_text =
                                                                                  "Hit " .. entity.get_player_name(player.target) .. "'s " .. hitbox .. " for " .. player.damage .. " damage."
                                                                                  if utility.table_contains(ui.get(menu.elements.settings_hitlogs), "- console -") then
                                                                                    client.color_log(255, 255, 255, "[\0")
                                                                                    client.color_log(script.color.r, script.color.g, script.color.b, script.name .. "\0")
                                                                                    client.color_log(255, 255, 255, "] \0")
                                                                                    client.color_log(255, 255, 255, "[\0")
                                                                                    client.color_log(script.color.r, script.color.g, script.color.b, player.id .. "\0")
                                                                                    client.color_log(255, 255, 255, "] \0")
                                                                                    client.color_log(255, 255, 255, hit_text)
                                                                                  end
                                                                                end
                                                                                functions.on_miss = function(player)
                                                                                  hitbox = hitboxes[player.hitgroup + 1] or "unknown"
                                                                                  miss_text =
                                                                                  "Missed " ..
                                                                                  entity.get_player_name(player.target) ..
                                                                                  "'s " .. hitbox .. " due to " .. (player.reason ~= "?" and player.reason or "resolver") .. "."
                                                                                  if utility.table_contains(ui.get(menu.elements.settings_hitlogs), "- console -") then
                                                                                    client.color_log(255, 255, 255, "[\0")
                                                                                    client.color_log(script.color.r, script.color.g, script.color.b, script.name .. "\0")
                                                                                    client.color_log(255, 255, 255, "] \0")
                                                                                    client.color_log(255, 255, 255, "[\0")
                                                                                    client.color_log(script.color.r, script.color.g, script.color.b, player.id .. "\0")
                                                                                    client.color_log(255, 255, 255, "] \0")
                                                                                    client.color_log(140, 140, 140, miss_text)
                                                                                  end
                                                                                end
                                                                                functions.clantag = function()
                                                                                  if ui.get(menu.elements.settings_clantag) ~= "- new -" and internal_database.settings.clantag then
                                                                                    internal_database.settings.clantag = false
                                                                                    client.set_clan_tag("")
                                                                                    return
                                                                                  end
                                                                                  if not internal_database.settings.clantag then
                                                                                    client.set_clan_tag("")
                                                                                    return
                                                                                  end
                                                                                  clantag_time = math.floor(globals.curtime() * 6)
                                                                                  current_id = (clantag_time % #script.clantag + 1)
                                                                                  if current_id ~= internal_database.settings.last_clantag then
                                                                                    client.set_clan_tag(script.clantag[current_id])
                                                                                    internal_database.settings.last_clantag = current_id
                                                                                  end
                                                                                end
                                                                                configs = {}
                                                                                configs.list = {}
                                                                                configs.update = function()
                                                                                configs.list = {}
                                                                                for id in next, external_database.configs do
                                                                                  table.insert(configs.list, id)
                                                                                end
                                                                                table.sort(configs.list)
                                                                                table.insert(configs.list, 1, "default")
                                                                                ui.update(menu.sub_elements.settings_list_config, configs.list)
                                                                              end
                                                                              configs.load = function(name)
                                                                              config_data = external_database.configs[name]
                                                                              success_base64, result_base64 = pcall(libraries.base64.decode, config_data)
                                                                              success_json, result_json = pcall(json.parse, libraries.base64.decode(config_data))
                                                                              if success_base64 and success_json then
                                                                                config_parsed_data = json.parse(libraries.base64.decode(config_data))
                                                                                for a_key, a_value in pairs(menu.elements) do
                                                                                  if type(a_value) ~= "table" then
                                                                                    if config_parsed_data[a_key] then
                                                                                      ui.set(a_value, config_parsed_data[a_key])
                                                                                    end
                                                                                  end
                                                                                  for id = 1, #script.conditions do
                                                                                    for b_key, b_value in pairs(menu.elements[script.conditions[id]]) do
                                                                                      if config_parsed_data[script.conditions[id] .. " " .. b_key] then
                                                                                        ui.set(b_value, config_parsed_data[script.conditions[id] .. " " .. b_key])
                                                                                      end
                                                                                    end
                                                                                  end
                                                                                end
                                                                              end
                                                                            end
                                                                            configs.save = function(name)
                                                                            config_data = {}

                                                                            for a_key, a_value in pairs(menu.elements) do
                                                                              if type(a_value) ~= "table" then
                                                                                config_data[a_key] = ui.get(a_value)
                                                                              end
                                                                              for id = 1, #script.conditions do
                                                                                for b_key, b_value in pairs(menu.elements[script.conditions[id]]) do
                                                                                  config_data[script.conditions[id] .. " " .. b_key] = ui.get(b_value)
                                                                                end
                                                                              end
                                                                            end
                                                                            external_database.configs[name] = libraries.base64.encode(json.stringify(config_data))
                                                                          end
                                                                          configs.delete = function(name)
                                                                          if name ~= "default" then
                                                                            external_database.configs[name] = nil
                                                                          end
                                                                        end
                                                                        configs.export = function()
                                                                        config_data = {}
                                                                        for a_key, a_value in pairs(menu.elements) do
                                                                          if type(a_value) ~= "table" then
                                                                            config_data[a_key] = ui.get(a_value)
                                                                          end
                                                                          for id = 1, #script.conditions do
                                                                            for b_key, b_value in pairs(menu.elements[script.conditions[id]]) do
                                                                              config_data[script.conditions[id] .. " " .. b_key] = ui.get(b_value)
                                                                            end
                                                                          end
                                                                        end
                                                                        libraries.clipboard.set(libraries.base64.encode(json.stringify(config_data)))
                                                                      end
                                                                      configs.import = function(config_data)
                                                                      success_base64, result_base64 = pcall(libraries.base64.decode, config_data)
                                                                      success_json, result_json = pcall(json.parse, libraries.base64.decode(config_data))
                                                                      if success_base64 and success_json then
                                                                        config_parsed_data = json.parse(libraries.base64.decode(config_data))
                                                                        for a_key, a_value in pairs(menu.elements) do
                                                                          if type(a_value) ~= "table" then
                                                                            if config_parsed_data[a_key] then
                                                                              ui.set(a_value, config_parsed_data[a_key])
                                                                            end
                                                                          end
                                                                          for id = 1, #script.conditions do
                                                                            for b_key, b_value in pairs(menu.elements[script.conditions[id]]) do
                                                                              if config_parsed_data[script.conditions[id] .. " " .. b_key] then
                                                                                ui.set(b_value, config_parsed_data[script.conditions[id] .. " " .. b_key])
                                                                              end
                                                                            end
                                                                          end
                                                                        end
                                                                      end
                                                                    end
                                                                    menu.sub_elements.settings_list_config = ui.new_listbox("AA", "Anti-aimbot angles", " ", {})
                                                                    menu.sub_elements.settings_name_config = ui.new_textbox("AA", "Anti-aimbot angles", " ")
                                                                    menu.sub_elements.settings_load_config =
                                                                    ui.new_button(
                                                                    "AA",
                                                                    "Anti-aimbot angles",
                                                                    "\a" .. utility.rgb_to_hex(255, 255, 255) .. "✨ load ✨",
                                                                    function()
                                                                      pcall(
                                                                      function()
                                                                        if configs.list[ui.get(menu.sub_elements.settings_list_config) + 1] ~= "default" then
                                                                          configs.load(configs.list[ui.get(menu.sub_elements.settings_list_config) + 1])
                                                                        else
                                                                          configs.import(
                                                                          "eyIrIGFlcm9iaWMgKyB5YXdfcmlnaHQiOjQyLCIrIGFlcm9iaWMgKyB5YXciOiItIGxlZnQgJiByaWdodCAtIiwiKyBnbG9iYWwgKyBkZWZlbnNpdmVfeWF3X2RlZ3JlZSI6MCwiKyBkdWNraW5nICsgeWF3X2RlbGF5IjoyLCIrIHJ1bm5pbmcgKyBib2R5X3lhd19kZWdyZWUiOi04OSwiKyBzdGFuZGluZyArIG92ZXJyaWRlIjp0cnVlLCIrIGdsb2JhbCArIGRlZmVuc2l2ZV9waXRjaF9kZWdyZWUiOjAsIisgY3JvdWNoaW5nICsgZGVmZW5zaXZlX3lhdyI6Ii0gZmxpY2sgLSIsIisgY3JvdWNoaW5nICsgZGVmZW5zaXZlX3NwZWVkIjo5LCIrIHN0YW5kaW5nICsgZGVmZW5zaXZlX2FhIjoiLSBub25lIC0iLCJzY3JpcHRfZW5hYmxlZCI6dHJ1ZSwiKyBjLWFlcm9iaWMgKyB5YXdfcmlnaHQiOjM1LCIrIGR1Y2tpbmcgKyB5YXdfcmlnaHQiOjMyLCIrIGNyb3VjaGluZyArIGRlZmVuc2l2ZV9waXRjaF9kZWdyZWUiOi02NywiKyB3YWxraW5nICsgeWF3X21vZGlmaWVyIjoiLSBjZW50ZXIgLSIsIisgZHVja2luZyArIGRlZmVuc2l2ZV9waXRjaF9kZWdyZWUiOi03MCwiKyBzdGFuZGluZyArIGRlZmVuc2l2ZV9waXRjaF9kZWdyZWUiOjAsIisgYWVyb2JpYyArIHlhd19sZWZ0IjotMzAsIisgcnVubmluZyArIGRlZmVuc2l2ZV9waXRjaF9kZWdyZWUiOjAsIisgYWVyb2JpYyArIGRlZmVuc2l2ZV9waXRjaF9kZWdyZWUiOi00NCwiKyBjLWFlcm9iaWMgKyB5YXdfZGVncmVlIjowLCIrIGdsb2JhbCArIHlhd19sZWZ0IjotMTMsIisgYy1hZXJvYmljICsgeWF3IjoiLSBsZWZ0ICYgcmlnaHQgLSIsInNldHRpbmdzX2hpdGxvZ3MiOlsiLSBjb25zb2xlIC0iXSwiKyBjcm91Y2hpbmcgKyBib2R5X3lhdyI6Ii0gY3VzdG9tIC0iLCIrIGFlcm9iaWMgKyB5YXdfbW9kaWZpZXJfb2Zmc2V0IjotMTQsIisgcnVubmluZyArIHlhd19tb2RpZmllciI6Ii0gY2VudGVyIC0iLCJzZXR0aW5nc190d2Vha3MiOlsiLSBmYXN0IGxhZGRlciAtIiwiLSBhbnRpIGJhY2tzdGFiIC0iLCItIHdhcm11cCBhYSAtIl0sIisgd2Fsa2luZyArIGRlZmVuc2l2ZV95YXciOiItIG5vbmUgLSIsIisgY3JvdWNoaW5nICsgeWF3X21vZGlmaWVyX29mZnNldCI6LTIsIisgYWVyb2JpYyArIHlhd19tb2RpZmllciI6Ii0gY2VudGVyIC0iLCIrIGMtYWVyb2JpYyArIGRlZmVuc2l2ZV9hYSI6Ii0gY3VzdG9tIC0iLCIrIGNyb3VjaGluZyArIG92ZXJyaWRlIjp0cnVlLCIrIGNyb3VjaGluZyArIGRlZmVuc2l2ZV9waXRjaCI6Ii0gdXAgLSIsIisgYWVyb2JpYyArIGRlZmVuc2l2ZV9zcGVlZCI6Mywic2NyaXB0X3RhYiI6IiDijJsgc2V0dGluZ3Mg4oybIiwiKyBzdGFuZGluZyArIHlhd19sZWZ0IjotMjUsIisgZ2xvYmFsICsgYm9keV95YXciOiItIG5vbmUgLSIsIisgY3JvdWNoaW5nICsgZGVmZW5zaXZlX2FhIjoiLSBjdXN0b20gLSIsIisgYy1hZXJvYmljICsgZGVmZW5zaXZlX3lhdyI6Ii0gZmxpY2sgLSIsIisgc3RhbmRpbmcgKyBkZWZlbnNpdmVfeWF3X2RlZ3JlZSI6MCwiKyBhZXJvYmljICsgYm9keV95YXciOiItIGN1c3RvbSAtIiwiKyBkdWNraW5nICsgZGVmZW5zaXZlX3BpdGNoIjoiLSB1cCAtIiwiKyBnbG9iYWwgKyB5YXciOiItIGdhbWVzZW5zZSAtIiwiKyBhZXJvYmljICsgZGVmZW5zaXZlX3lhd19kZWdyZWUiOi01NywiKyBzdGFuZGluZyArIGJvZHlfeWF3IjoiLSBjdXN0b20gLSIsIisgcnVubmluZyArIGRlZmVuc2l2ZV9zcGVlZCI6OCwiKyBjLWFlcm9iaWMgKyBvdmVycmlkZSI6dHJ1ZSwiKyBkdWNraW5nICsgZGVmZW5zaXZlX3lhdyI6Ii0gZmxpY2sgLSIsIisgZHVja2luZyArIHlhd19tb2RpZmllciI6Ii0gY2VudGVyIC0iLCIrIHJ1bm5pbmcgKyBkZWZlbnNpdmVfeWF3IjoiLSByYW5kb20gLSIsInNldHRpbmdzX3NhZmVfaGVhZCI6WyItIG9uIG1lbGVlIC0iXSwiKyBydW5uaW5nICsgeWF3X21vZGlmaWVyX29mZnNldCI6LTQsIisgZHVja2luZyArIGRlZmVuc2l2ZV9zcGVlZCI6OSwiKyBkdWNraW5nICsgZGVmZW5zaXZlX2FhIjoiLSBjdXN0b20gLSIsInNldHRpbmdzX2NhdGVnb3J5Ijoi4pi4IGNvbmZpZ3Mg4pi4IiwiKyBzdGFuZGluZyArIHlhd19tb2RpZmllcl9vZmZzZXQiOi02LCIrIHJ1bm5pbmcgKyBkZWZlbnNpdmVfcGl0Y2giOiItIHplcm8gLSIsIisgd2Fsa2luZyArIHlhd19tb2RpZmllcl9vZmZzZXQiOi0zLCIrIGMtYWVyb2JpYyArIHlhd19sZWZ0IjotMjUsImFudGlhaW1ib3RfY2F0ZWdvcnkiOiLinJ0gYnVpbGRlciDinJ0iLCIrIGR1Y2tpbmcgKyBib2R5X3lhdyI6Ii0gY3VzdG9tIC0iLCIrIGR1Y2tpbmcgKyB5YXdfZGVncmVlIjowLCIrIHJ1bm5pbmcgKyB5YXciOiItIGRlbGF5ZWQgLSIsIisgYy1hZXJvYmljICsgZGVmZW5zaXZlX3NwZWVkIjo4LCIrIGMtYWVyb2JpYyArIGRlZmVuc2l2ZV9waXRjaF9kZWdyZWUiOjAsIisgZHVja2luZyArIHlhdyI6Ii0gZGVsYXllZCAtIiwiKyBzdGFuZGluZyArIGRlZmVuc2l2ZV95YXciOiItIG5vbmUgLSIsIisgcnVubmluZyArIHlhd19sZWZ0IjotMjksIisgc3RhbmRpbmcgKyB5YXdfcmlnaHQiOjM4LCIrIHJ1bm5pbmcgKyBkZWZlbnNpdmVfYWEiOiItIG5vbmUgLSIsIisgYWVyb2JpYyArIGRlZmVuc2l2ZV9hYSI6Ii0gY3VzdG9tIC0iLCIrIGdsb2JhbCArIHlhd19yaWdodCI6MjcsIisgcnVubmluZyArIHlhd19kZWdyZWUiOjAsIisgY3JvdWNoaW5nICsgeWF3X2xlZnQiOi00LCIrIGMtYWVyb2JpYyArIGJvZHlfeWF3IjoiLSBjdXN0b20gLSIsIisgY3JvdWNoaW5nICsgeWF3X3JpZ2h0IjozOCwiKyBkdWNraW5nICsgZGVmZW5zaXZlX3lhd19kZWdyZWUiOjkwLCIrIHN0YW5kaW5nICsgeWF3X21vZGlmaWVyIjoiLSBjZW50ZXIgLSIsIisgd2Fsa2luZyArIGRlZmVuc2l2ZV9waXRjaCI6Ii0gbm9uZSAtIiwiKyBjcm91Y2hpbmcgKyB5YXdfZGVncmVlIjowLCIrIGFlcm9iaWMgKyB5YXdfZGVncmVlIjowLCIrIGNyb3VjaGluZyArIGJvZHlfeWF3X2RlZ3JlZSI6MCwiKyBydW5uaW5nICsgZGVmZW5zaXZlX3lhd19kZWdyZWUiOi04OCwiKyBzdGFuZGluZyArIGRlZmVuc2l2ZV9waXRjaCI6Ii0gbm9uZSAtIiwiKyB3YWxraW5nICsgZGVmZW5zaXZlX2FhIjoiLSBub25lIC0iLCIrIGFlcm9iaWMgKyBib2R5X3lhd19kZWdyZWUiOi0xNjUsIisgYy1hZXJvYmljICsgeWF3X2RlbGF5IjoxLCIrIGMtYWVyb2JpYyArIGRlZmVuc2l2ZV9waXRjaCI6Ii0gemVybyAtIiwiKyBnbG9iYWwgKyBkZWZlbnNpdmVfeWF3IjoiLSBub25lIC0iLCIrIHN0YW5kaW5nICsgeWF3X2RlbGF5Ijo0LCIrIHdhbGtpbmcgKyBib2R5X3lhdyI6Ii0gY3VzdG9tIC0iLCIrIHdhbGtpbmcgKyBvdmVycmlkZSI6dHJ1ZSwiKyBnbG9iYWwgKyBib2R5X3lhd19kZWdyZWUiOi03NSwiYW50aWFpbWJvdF9jb25kaXRpb24iOiIrIGFlcm9iaWMgKyIsInNldHRpbmdzX2NsYW50YWciOiItIG5vbmUgLSIsIisgc3RhbmRpbmcgKyBkZWZlbnNpdmVfc3BlZWQiOjgsIisgZ2xvYmFsICsgeWF3X2RlbGF5Ijo0LCIrIGMtYWVyb2JpYyArIHlhd19tb2RpZmllcl9vZmZzZXQiOi0xLCIrIHJ1bm5pbmcgKyB5YXdfcmlnaHQiOjM0LCIrIHN0YW5kaW5nICsgeWF3X2RlZ3JlZSI6MCwiKyB3YWxraW5nICsgeWF3X2RlbGF5Ijo2LCIrIHJ1bm5pbmcgKyB5YXdfZGVsYXkiOjQsIisgZ2xvYmFsICsgeWF3X2RlZ3JlZSI6MCwiKyBnbG9iYWwgKyB5YXdfbW9kaWZpZXJfb2Zmc2V0IjotOCwiKyBnbG9iYWwgKyBkZWZlbnNpdmVfc3BlZWQiOjgsIisgd2Fsa2luZyArIHlhd19kZWdyZWUiOjAsIisgd2Fsa2luZyArIGRlZmVuc2l2ZV9zcGVlZCI6OCwiKyB3YWxraW5nICsgYm9keV95YXdfZGVncmVlIjotNDEsIisgd2Fsa2luZyArIHlhd19yaWdodCI6MzQsIisgc3RhbmRpbmcgKyB5YXciOiItIGRlbGF5ZWQgLSIsIisgc3RhbmRpbmcgKyBib2R5X3lhd19kZWdyZWUiOi0zMCwiKyBnbG9iYWwgKyBkZWZlbnNpdmVfcGl0Y2giOiItIG5vbmUgLSIsIisgd2Fsa2luZyArIGRlZmVuc2l2ZV9waXRjaF9kZWdyZWUiOjAsIisgY3JvdWNoaW5nICsgZGVmZW5zaXZlX3lhd19kZWdyZWUiOjg4LCIrIGNyb3VjaGluZyArIHlhdyI6Ii0gZGVsYXllZCAtIiwiKyBjcm91Y2hpbmcgKyB5YXdfZGVsYXkiOjMsIisgcnVubmluZyArIGJvZHlfeWF3IjoiLSBjdXN0b20gLSIsIisgZHVja2luZyArIHlhd19tb2RpZmllcl9vZmZzZXQiOi0zLCIrIGFlcm9iaWMgKyBkZWZlbnNpdmVfeWF3IjoiLSBzcGluIC0iLCIrIGdsb2JhbCArIHlhd19tb2RpZmllciI6Ii0gbm9uZSAtIiwiKyBkdWNraW5nICsgeWF3X2xlZnQiOi0zLCIrIHdhbGtpbmcgKyBkZWZlbnNpdmVfeWF3X2RlZ3JlZSI6MCwiKyBkdWNraW5nICsgb3ZlcnJpZGUiOnRydWUsIisgcnVubmluZyArIG92ZXJyaWRlIjp0cnVlLCIrIGMtYWVyb2JpYyArIGRlZmVuc2l2ZV95YXdfZGVncmVlIjotOTAsIisgZ2xvYmFsICsgZGVmZW5zaXZlX2FhIjoiLSBub25lIC0iLCIrIGR1Y2tpbmcgKyBib2R5X3lhd19kZWdyZWUiOjAsIisgYWVyb2JpYyArIHlhd19kZWxheSI6MSwiKyBhZXJvYmljICsgZGVmZW5zaXZlX3BpdGNoIjoiLSB1cC1zd2l0Y2ggLSIsIisgYWVyb2JpYyArIG92ZXJyaWRlIjp0cnVlLCIrIGMtYWVyb2JpYyArIHlhd19tb2RpZmllciI6Ii0gY2VudGVyIC0iLCIrIHdhbGtpbmcgKyB5YXciOiItIGRlbGF5ZWQgLSIsIisgYy1hZXJvYmljICsgYm9keV95YXdfZGVncmVlIjotMzQsIisgY3JvdWNoaW5nICsgeWF3X21vZGlmaWVyIjoiLSBjZW50ZXIgLSIsIisgd2Fsa2luZyArIHlhd19sZWZ0IjotMzR9"
                                                                          )
                                                                        end
                                                                      end
                                                                      )
                                                                      configs.update()
                                                                    end
                                                                    )
                                                                    menu.sub_elements.settings_save_config =
                                                                    ui.new_button(
                                                                    "AA",
                                                                    "Anti-aimbot angles",
                                                                    "\a" .. utility.rgb_to_hex(255, 255, 255) .. "✨ save ✨",
                                                                    function()
                                                                      pcall(
                                                                      function()
                                                                        if
                                                                        configs.list[ui.get(menu.sub_elements.settings_name_config)] or
                                                                        ui.get(menu.sub_elements.settings_name_config):match("^%s*$")
                                                                        then
                                                                          if configs.list[ui.get(menu.sub_elements.settings_list_config) + 1] ~= "default" then
                                                                            configs.save(configs.list[ui.get(menu.sub_elements.settings_list_config) + 1])
                                                                          end
                                                                        else
                                                                          if ui.get(menu.sub_elements.settings_name_config) ~= "default" then
                                                                            configs.save(ui.get(menu.sub_elements.settings_name_config))
                                                                          end
                                                                        end
                                                                      end
                                                                      )
                                                                      configs.update()
                                                                    end
                                                                    )
                                                                    menu.sub_elements.settings_delete_config =
                                                                    ui.new_button(
                                                                    "AA",
                                                                    "Anti-aimbot angles",
                                                                    "\a" .. utility.rgb_to_hex(255, 255, 255) .. "✨ delete ✨",
                                                                    function()
                                                                      pcall(
                                                                      function()
                                                                        if configs.list[ui.get(menu.sub_elements.settings_list_config) + 1] ~= "default" then
                                                                          configs.delete(configs.list[ui.get(menu.sub_elements.settings_list_config) + 1])
                                                                        end
                                                                      end
                                                                      )
                                                                      configs.update()
                                                                    end
                                                                    )
                                                                    menu.sub_elements.settings_import_config =
                                                                    ui.new_button(
                                                                    "AA",
                                                                    "Anti-aimbot angles",
                                                                    "\a" .. utility.rgb_to_hex(255, 255, 255) .. "✨ import ✨",
                                                                    function()
                                                                      pcall(
                                                                      function()
                                                                        configs.import(libraries.clipboard.get())
                                                                      end
                                                                      )
                                                                      configs.update()
                                                                    end
                                                                    )
                                                                    menu.sub_elements.settings_export_config =
                                                                    ui.new_button(
                                                                    "AA",
                                                                    "Anti-aimbot angles",
                                                                    "\a" .. utility.rgb_to_hex(255, 255, 255) .. "✨ export ✨",
                                                                    function()
                                                                      pcall(
                                                                      function()
                                                                        configs.export()
                                                                      end
                                                                      )
                                                                      configs.update()
                                                                    end
                                                                    )
                                                                    callbacks = {}
                                                                    callbacks.paint_ui =
                                                                    client.set_event_callback(
                                                                    "paint_ui",
                                                                    function()
                                                                      functions.menu_setup()
                                                                        functions.watermark()
                                                                        end
                                                                        )
                                                                        client.set_event_callback(
                                                                        "setup_command",
                                                                        function(cmd)
                                                                          functions.update_force_defensive(cmd)
                                                                            functions.update_antiaimbot(cmd)
                                                                              functions.update_database(cmd)
                                                                                functions.tweaks(cmd)
                                                                                end
                                                                                )
                                                                                client.set_event_callback(
                                                                                "predict_command",
                                                                                function(cmd)
                                                                                  functions.update_defensive_ticks(cmd)
                                                                                  end
                                                                                  )
                                                                                  client.set_event_callback(
                                                                                  "finish_command",
                                                                                  function(cmd)
                                                                                    functions.update_last_command(cmd)
                                                                                    end
                                                                                    )
                                                                                    client.set_event_callback(
                                                                                    "net_update_end",
                                                                                    function()
                                                                                      functions.clantag()
                                                                                      end
                                                                                      )
                                                                                      client.set_event_callback(
                                                                                      "aim_hit",
                                                                                      function(entity)
                                                                                        functions.on_hit(entity)
                                                                                        end
                                                                                        )
                                                                                        client.set_event_callback(
                                                                                        "aim_miss",
                                                                                        function(entity)
                                                                                          functions.on_miss(entity)
                                                                                          end
                                                                                          )
                                                                                          client.set_event_callback(
                                                                                          "shutdown",
                                                                                          function()
                                                                                            functions.hide_script_tab(false)
                                                                                              client.set_clan_tag("")
                                                                                            end
                                                                                            )
                                                                                            ui.set_callback(menu.sub_elements.settings_list_config, configs.update)
                                                                                            ui.set_callback(
                                                                                            menu.elements.settings_clantag,
                                                                                            function(value)
                                                                                              if value then
                                                                                                internal_database.settings.clantag = true
                                                                                              else
                                                                                                internal_database.settings.clantag = false
                                                                                                client.set_clan_tag("")
                                                                                              end
                                                                                            end
                                                                                            )

                                                                                            -- @region: end

                                                                                            configs.update()