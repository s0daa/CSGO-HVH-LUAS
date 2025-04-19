---@region lib
local ffi = require('ffi')
local pui = require("gamesense/pui")
local vector = require("vector")
local clipboard = require('gamesense/clipboard')
local json = require('json')
local base64 = require('gamesense/base64')
local anti_aim = require('gamesense/antiaim_funcs')
local c_entity = require("gamesense/entity")
---@end

---@region lua info
local info = {
    lua_name = "excellent",
    lua_build = "basic",
    user = _USER_NAME or "admin",
}
---@end

---@region reference
local ref = {
    enabled = ui.reference("AA", "Anti-Aimbot angles", "Enabled"),
    pitch = {ui.reference("AA", "Anti-Aimbot angles", "Pitch")},
    yaw_base = ui.reference("AA", "Anti-Aimbot angles", "Yaw base"),
    yaw = {ui.reference("AA", "Anti-Aimbot angles", "Yaw")},
    yaw_jitter = {ui.reference("AA", "Anti-Aimbot angles", "Yaw jitter")},
    body_yaw = {ui.reference("AA", "Anti-Aimbot angles", "Body yaw")},
    freestanding_body_yaw = ui.reference("AA", "Anti-Aimbot angles", "Freestanding body yaw"),
    edge_yaw = ui.reference("AA", "Anti-Aimbot angles", "Edge yaw"),
    freestand = {ui.reference("AA", "Anti-Aimbot angles", "Freestanding")},
    roll = ui.reference("AA", "Anti-Aimbot angles", "Roll"),
    slow_walk = {ui.reference("AA", "Other", "Slow motion")},
    dt = {ui.reference("RAGE", "Aimbot", "Double Tap")},
    hs = {ui.reference("AA", "Other", "On shot anti-aim")},
    fd = ui.reference("RAGE", "Other", "Duck peek assist"),
    min_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    min_damage_override = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
    rage_cb = {ui.reference("RAGE", "Aimbot", "Enabled")},
    menu_color = ui.reference("MISC", "Settings", "Menu color"),
    fake_lag_enabled = {ui.reference("AA", "Fake lag", "Enabled")},
    fake_lag_variance = ui.reference("AA", "Fake lag", "Variance"),
    fake_lag_limit = ui.reference("AA", "Fake lag", "Limit"),
    fake_lag_amount = ui.reference("AA", "Fake lag", "Amount"),
    ac_boost = ui.reference("RAGE", "Other", "Accuracy boost")
}
---@end

---@region tools
local tools = {
    lerp = function(a, b, t)
        return a + (b - a) * t
    end,
    to_hex = function(r, g, b, a)
        return string.format("%02x%02x%02x%02x", r, g, b, a)
    end,
    clamp = function(value, min, max)
        return math.max(min, math.min(max, value))
    end,
    draw_glow_edges = function(x, y, width, height, color, max_intensity, layers)
        for i = 1, layers do
            local alpha = tools.clamp(max_intensity - (i * (max_intensity / layers)), 0, max_intensity)
            local offset = i - 1

            renderer.rectangle(x - offset, y - offset, 1, height + offset * 2, color[1], color[2], color[3], alpha)
            renderer.rectangle(x + width + offset, y - offset, 1, height + offset * 2, color[1], color[2], color[3], alpha)

            renderer.rectangle(x, y - offset, width, 1, color[1], color[2], color[3], alpha)
            renderer.rectangle(x, y + height + offset, width, 1, color[1], color[2], color[3], alpha)
        end
    end
}
---@end

---@region exploit_data
local exploit_data = {
    shift = 0,
    charged = false,
    update = false,
    manual_shot = 0,
    shot = 0,
}
---@end

---@region gui
local fake_lag_switch = pui.checkbox("AA", "Fake lag", "Enabled")
local fake_lag_combo = pui.combobox("AA", "Fake lag", "Type", "Maximum", "Cycle", "Fluctuate")
local fake_lag_slider = pui.slider("AA", "Fake lag", "Limit", 1, 15, 0)
local label = pui.button("AA", "Anti-Aimbot angles", pui.format("\vE X C E L L E N T"))
local post_label = pui.label("AA", "Anti-Aimbot angles", pui.format(" "))

local tab_selector = pui.combobox("AA", "Anti-aimbot angles", "Current Tab", " Info", " AA", " Tweaks", " Visuals", " Debug")
local placeholder = pui.label("AA", "Anti-aimbot angles", "   ")

local function selected_tab_get()
    if tab_selector:get() == " Info" then
        selected_tab = 1
    elseif tab_selector:get() == " AA" then
        selected_tab = 2
    elseif tab_selector:get() == " Tweaks" then
        selected_tab = 4
    elseif tab_selector:get() == " Visuals" then
        selected_tab = 3
    elseif tab_selector:get() == " Debug" then
        selected_tab = 5
    end
end
selected_tab_get()

tab_selector:set_callback(selected_tab_get)

local state_selector = pui.combobox("AA", "Anti-Aimbot angles", "State", {"Global", "Stand", "Walk", "SlowWalk", "Air", "Airduck", "Duck", "DuckRun", "Freestand", "FakeLag"})

local state = {"Global", "Stand", "Walk", "SlowWalk", "Air", "Airduck", "Duck", "DuckRun", "Freestand", "FakeLag"}
local state_settings = {}
local menu_color_hex = tools.to_hex(ui.get(ref.menu_color))

for _, state_name in ipairs(state) do
    local state_color = string.format('\a%s', menu_color_hex)
    local default_color = '\aC0C0C0FF'

    state_settings[state_name] = {
        allow = pui.checkbox("AA", "Anti-Aimbot angles", string.format('%s%s %sAllow', state_color, state_name, default_color)),
        yaw_type = pui.combobox("AA", "Anti-Aimbot angles", string.format('%s%s%s yaw', state_color, state_name, default_color), {"180", "Delayed", "Fake"}),
        global_yaw = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s yaw add', state_color, state_name, default_color), -180, 180, 0, true, "°"),
        left_yaw = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s left yaw add', state_color, state_name, default_color), -180, 180, 0, true, "°"),
        real_yaw = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s real yaw', state_color, state_name, default_color), -180, 180, 0, true, "°"),
        fake_yaw = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s fake yaw', state_color, state_name, default_color), -180, 180, 0, true, "°"),
        right_yaw = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s right yaw add', state_color, state_name, default_color), -180, 180, 0, true, "°"),
        random = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s randomize yaw', state_color, state_name, default_color), 0, 100, 0, true, "%"),
        yaw_jitter_combo = pui.combobox("AA", "Anti-Aimbot angles", string.format('%s%s%s yaw jitter', state_color, state_name, default_color), {"Off", "Offset", "Center", "Random", "Skitter"}),
        yaw_jitter_value = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s yaw jitter value', state_color, state_name, default_color), -180, 180, 0, true, "°"),
        body_yaw_combo = pui.combobox("AA", "Anti-Aimbot angles", string.format('%s%s%s body yaw', state_color, state_name, default_color), {"Left", "Right", "Jitter"}),
        body_yaw_value = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s body yaw value', state_color, state_name, default_color), 0, 60, 0, true, "°"),
        jitter_delay = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s jitter delay', state_color, state_name, default_color), 1, 14, 1, true, "t"),
        randomize_jitter_delay = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s randomize jitter delay', state_color, state_name, default_color), 0, 10, 0, true, "t"),
        anti_brute = pui.checkbox("AA", "Anti-Aimbot angles", string.format('%s%s %sclever anti-aim', state_color, state_name, default_color)),
    }

    if state_name ~= "FakeLag" then
        state_settings[state_name].defensive_checkbox = pui.checkbox("AA", "Anti-Aimbot angles", string.format('%s%s%s defensive', state_color, state_name, default_color))
        state_settings[state_name].defensive_type = pui.combobox("AA", "Anti-Aimbot angles", string.format('%s%s%s break LC', state_color, state_name, default_color), {"On Peek", "Always On", "Flick"})
        state_settings[state_name].defensive_pitch_combo = pui.combobox("AA", "Anti-Aimbot angles", string.format('%s%s%s defensive pitch', state_color, state_name, default_color), {"Custom", "Sway", "Jitter", "Random", "Lerp"})
        state_settings[state_name].defensive_pitch_custom = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s custom pitch', state_color, state_name, default_color), -89, 89, 0)
        state_settings[state_name].defensive_pitch_sway_from = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s sway from', state_color, state_name, default_color), -89, 89, 0)
        state_settings[state_name].defensive_pitch_sway_to = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s sway to', state_color, state_name, default_color), -89, 89, 0)
        state_settings[state_name].defensive_pitch_sway_shift = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s sway shift', state_color, state_name, default_color), 1, 10, 1)
        state_settings[state_name].defensive_pitch_jitter_from = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s jitter from', state_color, state_name, default_color), -89, 89, 0)
        state_settings[state_name].defensive_pitch_jitter_to = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s jitter to', state_color, state_name, default_color), -89, 89, 0)
        state_settings[state_name].defensive_pitch_random_from = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s random from', state_color, state_name, default_color), -89, 89, 0)
        state_settings[state_name].defensive_pitch_random_to = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s random to', state_color, state_name, default_color), -89, 89, 0)
        state_settings[state_name].defensive_yaw_combo = pui.combobox("AA", "Anti-Aimbot angles", string.format('%s%s%s defensive yaw', state_color, state_name, default_color), {"Custom", "Jitter", "Jitter v2", "Opposite", "Spin", "Random"})
        state_settings[state_name].defensive_yaw_custom = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s yaw', state_color, state_name, default_color), -180, 180, 0)
        state_settings[state_name].defensive_yaw_jitter_left = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s jitter left', state_color, state_name, default_color), -180, 180, 0)
        state_settings[state_name].defensive_yaw_jitter_right = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s jitter right', state_color, state_name, default_color), -180, 180, 0)
        state_settings[state_name].defensive_yaw_spin_speed = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s spin speed', state_color, state_name, default_color), 0, 100, 0)
        state_settings[state_name].defensive_yaw_random_from = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s random from', state_color, state_name, default_color), -180, 180, 0)
        state_settings[state_name].defensive_yaw_random_to = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s random to', state_color, state_name, default_color), -180, 180, 0)
        state_settings[state_name].defensive_yaw_jitter_combo = pui.combobox("AA", "Anti-Aimbot angles", string.format('%s%s%s defensive yaw jitter', state_color, state_name, default_color), {"Off", "Offset", "Center", "Random", "Skitter"})
        state_settings[state_name].defensive_yaw_jitter_value = pui.slider("AA", "Anti-Aimbot angles", string.format('%s%s%s defensive yaw jitter value', state_color, state_name, default_color), -180, 180, 0)
    end
end

local info_elements = {
    updoot = pui.label("AA", "Anti-aimbot angles", "Last update: 09.02.2025"),
    free_label = pui.label("AA", "Anti-aimbot angles", " "),
    username = pui.label("AA", "Anti-aimbot angles", "                       user - "..info.user),
    placeholder2 = pui.label("AA", "Anti-aimbot angles", "      "),
    discord_link_button = pui.button("AA", "Anti-aimbot angles", "Discord", function()  
        panorama.open().SteamOverlayAPI.OpenExternalBrowserURL("discord.gg/fastleaks") 
    end),
    neverlose_link_button = pui.button("AA", "Anti-aimbot angles", "Neverlose lua", function()  
        panorama.open().SteamOverlayAPI.OpenExternalBrowserURL("https://ru.neverlose.cc/market/item?id=YTWZhf") 
    end),
    youtube_link_button = pui.button("AA", "Anti-aimbot angles", "YouTube", function()  
        panorama.open().SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@santy-meaw") 
    end),
    placeholder = pui.label("AA", "Fake lag", "     "),
    session_time = pui.label("AA", "Fake lag", "Session time : 0 min 0 sec")
}

local visuals_elements = {
    animfix = pui.multiselect("AA", "Anti-aimbot angles", "Animfix", "Jitter legs", "Body lean", "0 pitch on landing"),
    centered_indicators = pui.checkbox("AA", "Anti-aimbot angles", "Center Indicators"),
    hit_logs = pui.checkbox("AA", "Anti-aimbot angles", "Hit logs"),
    damage_indicator = pui.checkbox("AA", "Anti-aimbot angles", "Animated Minimum damage indicator"),
    debug_panel = pui.checkbox("AA", "Anti-aimbot angles", "Debug panel"),
}

local misc_elements = {
    freestand = pui.hotkey("AA", "Anti-aimbot angles", "Freestanding"),
    freestand_disabler = pui.multiselect("AA", "Anti-aimbot angles", "Freestanding Disabler", {"Stand", "Walk", "SlowWalk", "Air", "Airduck", "Duck", "DuckRun", "FakeLag"}),
    razdelenie_placeholder = pui.label("AA", "Anti-aimbot angles", "  "),
    manual_left_bind = pui.hotkey("AA", "Anti-aimbot angles", "Manual left"),
    manual_right_bind = pui.hotkey("AA", "Anti-aimbot angles", "Manual right"),
    manual_forward_bind = pui.hotkey("AA", "Anti-aimbot angles", "Manual forward"),
    razdelenie_placeholder2 = pui.label("AA", "Anti-aimbot angles", "   "),
    warmup_aa = pui.checkbox("AA", "Anti-Aimbot angles", "Warmup AA"),
    revolver_helper = pui.checkbox("AA", "Anti-aimbot angles", "Revolver helper"),
    anti_backstab = pui.checkbox("AA", "Anti-Aimbot angles", "Anti Backstab"),
    fast_ladder = pui.checkbox("AA", "Anti-aimbot angles", "Fast ladder"),
    safe_head = pui.checkbox("AA", "Anti-aimbot angles", "Safe-head"),
}

local debug_elements = {
    defensive_check_type = pui.combobox("AA", "Anti-Aimbot angles", "Defensive check type", {"predict_command", "frame_stage_notify"}),
    defensive_check_slider1 = pui.slider("AA", "Anti-Aimbot angles", "Defensive tick min", 1, 13, 2),
    defensive_check_slider2 = pui.slider("AA", "Anti-Aimbot angles", "Defensive tick max", 1, 13, 12),
    resolver_checkbox = pui.checkbox("AA", "Anti-Aimbot angles", "Desync correction")
}

---@config
local config_items = {
    fake_lag_switch = fake_lag_switch,
    fake_lag_combo = fake_lag_combo,
    fake_lag_slider = fake_lag_slider,
    state_selector = state_selector,
    state_settings = state_settings,
    visuals = visuals_elements,
    misc = misc_elements,
    debug = debug_elements
}
local package = pui.setup(config_items)
local configs = {}

configs.export = function()
    local data = package:save()
    local encrypted = base64.encode(json.stringify(data))
    clipboard.set(encrypted)
    client.exec("Play ambient/tones/elev1")
    print("Configuration exported to clipboard.")
end

configs.import = function(input)
    local decrypted_data = base64.decode(input or clipboard.get())
    local data = json.parse(decrypted_data)
    if data then
        package:load(data)
        client.exec("Play ambient/tones/elev1")
        print("Configuration loaded from clipboard.")
    else
        print("Error: Failed to load configuration.")
    end
end

local placeholder2 = pui.label("AA", "Fake lag", "      ")
local default_button = pui.button("AA", "Fake lag", "Default", function() configs.import("eyJ2aXN1YWxzIjp7ImNlbnRlcmVkX2luZGljYXRvcnMiOmZhbHNlLCJkZWJ1Z19wYW5lbCI6dHJ1ZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiYW5pbWZpeCI6WyJKaXR0ZXIgbGVncyIsIkJvZHkgbGVhbiIsIn4iXSwiaGl0X2xvZ3MiOnRydWV9LCJkZWJ1ZyI6eyJkZWZlbnNpdmVfY2hlY2tfc2xpZGVyMiI6MTMsInJlc29sdmVyX2NoZWNrYm94Ijp0cnVlLCJkZWZlbnNpdmVfY2hlY2tfc2xpZGVyMSI6MywiZGVmZW5zaXZlX2NoZWNrX3R5cGUiOiJwcmVkaWN0X2NvbW1hbmQifSwiZmFrZV9sYWdfY29tYm8iOiJNYXhpbXVtIiwibWlzYyI6eyJtYW51YWxfZm9yd2FyZF9iaW5kIjpbMSwwLCJ+Il0sIm1hbnVhbF9sZWZ0X2JpbmQiOlsxLDAsIn4iXSwiZmFzdF9sYWRkZXIiOnRydWUsInNhZmVfaGVhZCI6dHJ1ZSwiZnJlZXN0YW5kIjpbMSwxOCwifiJdLCJ3YXJtdXBfYWEiOnRydWUsImZyZWVzdGFuZF9kaXNhYmxlciI6WyJTbG93V2FsayIsIkFpciIsIkFpcmR1Y2siLCJEdWNrUnVuIiwifiJdLCJyZXZvbHZlcl9oZWxwZXIiOnRydWUsImFudGlfYmFja3N0YWIiOnRydWUsIm1hbnVhbF9yaWdodF9iaW5kIjpbMSwwLCJ+Il19LCJzdGF0ZV9zZWxlY3RvciI6IkZyZWVzdGFuZCIsImZha2VfbGFnX3N3aXRjaCI6dHJ1ZSwiZmFrZV9sYWdfc2xpZGVyIjoxNSwic3RhdGVfc2V0dGluZ3MiOnsiV2FsayI6eyJnbG9iYWxfeWF3IjowLCJib2R5X3lhd19jb21ibyI6IkppdHRlciIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfdG8iOjAsImRlZmVuc2l2ZV9waXRjaF9jb21ibyI6IkN1c3RvbSIsImRlZmVuc2l2ZV9jaGVja2JveCI6ZmFsc2UsInlhd19qaXR0ZXJfY29tYm8iOiJPZmYiLCJsZWZ0X3lhdyI6LTIzLCJkZWZlbnNpdmVfcGl0Y2hfcmFuZG9tX2Zyb20iOjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3ZhbHVlIjowLCJkZWZlbnNpdmVfcGl0Y2hfc3dheV9mcm9tIjowLCJyYW5kb20iOjAsImRlZmVuc2l2ZV95YXdfcmFuZG9tX2Zyb20iOjAsImZha2VfeWF3IjowLCJyaWdodF95YXciOjM5LCJhbnRpX2JydXRlIjp0cnVlLCJqaXR0ZXJfZGVsYXkiOjQsImRlZmVuc2l2ZV95YXdfaml0dGVyX3JpZ2h0IjowLCJib2R5X3lhd192YWx1ZSI6MjcsInJhbmRvbWl6ZV9qaXR0ZXJfZGVsYXkiOjEsImRlZmVuc2l2ZV9waXRjaF9jdXN0b20iOjAsImRlZmVuc2l2ZV95YXdfcmFuZG9tX3RvIjowLCJyZWFsX3lhdyI6MCwiZGVmZW5zaXZlX3BpdGNoX3N3YXlfdG8iOjAsInlhd190eXBlIjoiRGVsYXllZCIsImRlZmVuc2l2ZV9waXRjaF9zd2F5X3NoaWZ0IjoxLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9jb21ibyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaF9yYW5kb21fdG8iOjAsImFsbG93Ijp0cnVlLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9sZWZ0IjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJkZWZlbnNpdmVfeWF3X2N1c3RvbSI6MSwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9mcm9tIjowLCJkZWZlbnNpdmVfeWF3X2NvbWJvIjoiQ3VzdG9tIiwiZGVmZW5zaXZlX3R5cGUiOiJPbiBQZWVrIiwiZGVmZW5zaXZlX3lhd19zcGluX3NwZWVkIjowfSwiU3RhbmQiOnsiZ2xvYmFsX3lhdyI6MCwiYm9keV95YXdfY29tYm8iOiJMZWZ0IiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl90byI6NSwiZGVmZW5zaXZlX3BpdGNoX2NvbWJvIjoiSml0dGVyIiwiZGVmZW5zaXZlX2NoZWNrYm94IjpmYWxzZSwieWF3X2ppdHRlcl9jb21ibyI6IkNlbnRlciIsImxlZnRfeWF3IjowLCJkZWZlbnNpdmVfcGl0Y2hfcmFuZG9tX2Zyb20iOjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3ZhbHVlIjotMTksImRlZmVuc2l2ZV9waXRjaF9zd2F5X2Zyb20iOjAsInJhbmRvbSI6MCwiZGVmZW5zaXZlX3lhd19yYW5kb21fZnJvbSI6MCwiZmFrZV95YXciOjU1LCJyaWdodF95YXciOjAsImFudGlfYnJ1dGUiOmZhbHNlLCJqaXR0ZXJfZGVsYXkiOjEsImRlZmVuc2l2ZV95YXdfaml0dGVyX3JpZ2h0IjowLCJib2R5X3lhd192YWx1ZSI6MCwicmFuZG9taXplX2ppdHRlcl9kZWxheSI6MCwiZGVmZW5zaXZlX3BpdGNoX2N1c3RvbSI6MCwiZGVmZW5zaXZlX3lhd19yYW5kb21fdG8iOjAsInJlYWxfeWF3IjotNTAsImRlZmVuc2l2ZV9waXRjaF9zd2F5X3RvIjowLCJ5YXdfdHlwZSI6IkZha2UiLCJkZWZlbnNpdmVfcGl0Y2hfc3dheV9zaGlmdCI6MSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfY29tYm8iOiJTa2l0dGVyIiwiZGVmZW5zaXZlX3BpdGNoX3JhbmRvbV90byI6MCwiYWxsb3ciOnRydWUsImRlZmVuc2l2ZV95YXdfaml0dGVyX2xlZnQiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjEyLCJkZWZlbnNpdmVfeWF3X2N1c3RvbSI6MiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9mcm9tIjotNSwiZGVmZW5zaXZlX3lhd19jb21ibyI6IlJhbmRvbSIsImRlZmVuc2l2ZV90eXBlIjoiRmxpY2siLCJkZWZlbnNpdmVfeWF3X3NwaW5fc3BlZWQiOjB9LCJEdWNrUnVuIjp7Imdsb2JhbF95YXciOjAsImJvZHlfeWF3X2NvbWJvIjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl90byI6MCwiZGVmZW5zaXZlX3BpdGNoX2NvbWJvIjoiQ3VzdG9tIiwiZGVmZW5zaXZlX2NoZWNrYm94IjpmYWxzZSwieWF3X2ppdHRlcl9jb21ibyI6Ik9mZiIsImxlZnRfeWF3IjotMzAsImRlZmVuc2l2ZV9waXRjaF9yYW5kb21fZnJvbSI6MCwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfdmFsdWUiOjAsImRlZmVuc2l2ZV9waXRjaF9zd2F5X2Zyb20iOjAsInJhbmRvbSI6MCwiZGVmZW5zaXZlX3lhd19yYW5kb21fZnJvbSI6MCwiZmFrZV95YXciOjAsInJpZ2h0X3lhdyI6NDEsImFudGlfYnJ1dGUiOnRydWUsImppdHRlcl9kZWxheSI6MSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfcmlnaHQiOjAsImJvZHlfeWF3X3ZhbHVlIjo1NywicmFuZG9taXplX2ppdHRlcl9kZWxheSI6NCwiZGVmZW5zaXZlX3BpdGNoX2N1c3RvbSI6MCwiZGVmZW5zaXZlX3lhd19yYW5kb21fdG8iOjAsInJlYWxfeWF3IjowLCJkZWZlbnNpdmVfcGl0Y2hfc3dheV90byI6MCwieWF3X3R5cGUiOiJEZWxheWVkIiwiZGVmZW5zaXZlX3BpdGNoX3N3YXlfc2hpZnQiOjEsImRlZmVuc2l2ZV95YXdfaml0dGVyX2NvbWJvIjoiT2ZmIiwiZGVmZW5zaXZlX3BpdGNoX3JhbmRvbV90byI6MCwiYWxsb3ciOnRydWUsImRlZmVuc2l2ZV95YXdfaml0dGVyX2xlZnQiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsImRlZmVuc2l2ZV95YXdfY3VzdG9tIjoxLCJkZWZlbnNpdmVfcGl0Y2hfaml0dGVyX2Zyb20iOjAsImRlZmVuc2l2ZV95YXdfY29tYm8iOiJDdXN0b20iLCJkZWZlbnNpdmVfdHlwZSI6Ik9uIFBlZWsiLCJkZWZlbnNpdmVfeWF3X3NwaW5fc3BlZWQiOjB9LCJBaXJkdWNrIjp7Imdsb2JhbF95YXciOjAsImJvZHlfeWF3X2NvbWJvIjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl90byI6MCwiZGVmZW5zaXZlX3BpdGNoX2NvbWJvIjoiUmFuZG9tIiwiZGVmZW5zaXZlX2NoZWNrYm94IjpmYWxzZSwieWF3X2ppdHRlcl9jb21ibyI6Ik9mZiIsImxlZnRfeWF3IjotMTMsImRlZmVuc2l2ZV9waXRjaF9yYW5kb21fZnJvbSI6ODksImRlZmVuc2l2ZV95YXdfaml0dGVyX3ZhbHVlIjo1OSwiZGVmZW5zaXZlX3BpdGNoX3N3YXlfZnJvbSI6MCwicmFuZG9tIjowLCJkZWZlbnNpdmVfeWF3X3JhbmRvbV9mcm9tIjo4OSwiZmFrZV95YXciOjUxLCJyaWdodF95YXciOjQ2LCJhbnRpX2JydXRlIjp0cnVlLCJqaXR0ZXJfZGVsYXkiOjEsImRlZmVuc2l2ZV95YXdfaml0dGVyX3JpZ2h0IjowLCJib2R5X3lhd192YWx1ZSI6NjAsInJhbmRvbWl6ZV9qaXR0ZXJfZGVsYXkiOjQsImRlZmVuc2l2ZV9waXRjaF9jdXN0b20iOjg5LCJkZWZlbnNpdmVfeWF3X3JhbmRvbV90byI6LTg5LCJyZWFsX3lhdyI6LTIwLCJkZWZlbnNpdmVfcGl0Y2hfc3dheV90byI6MCwieWF3X3R5cGUiOiJEZWxheWVkIiwiZGVmZW5zaXZlX3BpdGNoX3N3YXlfc2hpZnQiOjEsImRlZmVuc2l2ZV95YXdfaml0dGVyX2NvbWJvIjoiUmFuZG9tIiwiZGVmZW5zaXZlX3BpdGNoX3JhbmRvbV90byI6LTg5LCJhbGxvdyI6dHJ1ZSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfbGVmdCI6MCwieWF3X2ppdHRlcl92YWx1ZSI6LTUyLCJkZWZlbnNpdmVfeWF3X2N1c3RvbSI6MSwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9mcm9tIjowLCJkZWZlbnNpdmVfeWF3X2NvbWJvIjoiUmFuZG9tIiwiZGVmZW5zaXZlX3R5cGUiOiJGbGljayIsImRlZmVuc2l2ZV95YXdfc3Bpbl9zcGVlZCI6NDR9LCJGcmVlc3RhbmQiOnsiZ2xvYmFsX3lhdyI6MCwiYm9keV95YXdfY29tYm8iOiJKaXR0ZXIiLCJkZWZlbnNpdmVfcGl0Y2hfaml0dGVyX3RvIjowLCJkZWZlbnNpdmVfcGl0Y2hfY29tYm8iOiJDdXN0b20iLCJkZWZlbnNpdmVfY2hlY2tib3giOmZhbHNlLCJ5YXdfaml0dGVyX2NvbWJvIjoiT2ZmIiwibGVmdF95YXciOjAsImRlZmVuc2l2ZV9waXRjaF9yYW5kb21fZnJvbSI6MCwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfdmFsdWUiOjAsImRlZmVuc2l2ZV9waXRjaF9zd2F5X2Zyb20iOjAsInJhbmRvbSI6MCwiZGVmZW5zaXZlX3lhd19yYW5kb21fZnJvbSI6MCwiZmFrZV95YXciOjAsInJpZ2h0X3lhdyI6MCwiYW50aV9icnV0ZSI6ZmFsc2UsImppdHRlcl9kZWxheSI6MSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfcmlnaHQiOjAsImJvZHlfeWF3X3ZhbHVlIjo2MCwicmFuZG9taXplX2ppdHRlcl9kZWxheSI6MCwiZGVmZW5zaXZlX3BpdGNoX2N1c3RvbSI6LTg5LCJkZWZlbnNpdmVfeWF3X3JhbmRvbV90byI6MCwicmVhbF95YXciOjAsImRlZmVuc2l2ZV9waXRjaF9zd2F5X3RvIjowLCJ5YXdfdHlwZSI6IjE4MCIsImRlZmVuc2l2ZV9waXRjaF9zd2F5X3NoaWZ0IjoxLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9jb21ibyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaF9yYW5kb21fdG8iOjAsImFsbG93Ijp0cnVlLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9sZWZ0IjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJkZWZlbnNpdmVfeWF3X2N1c3RvbSI6MCwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9mcm9tIjowLCJkZWZlbnNpdmVfeWF3X2NvbWJvIjoiU3BpbiIsImRlZmVuc2l2ZV90eXBlIjoiQWx3YXlzIE9uIiwiZGVmZW5zaXZlX3lhd19zcGluX3NwZWVkIjo1OH0sIlNsb3dXYWxrIjp7Imdsb2JhbF95YXciOjAsImJvZHlfeWF3X2NvbWJvIjoiTGVmdCIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfdG8iOjQwLCJkZWZlbnNpdmVfcGl0Y2hfY29tYm8iOiJDdXN0b20iLCJkZWZlbnNpdmVfY2hlY2tib3giOmZhbHNlLCJ5YXdfaml0dGVyX2NvbWJvIjoiQ2VudGVyIiwibGVmdF95YXciOjAsImRlZmVuc2l2ZV9waXRjaF9yYW5kb21fZnJvbSI6MCwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfdmFsdWUiOi0zNywiZGVmZW5zaXZlX3BpdGNoX3N3YXlfZnJvbSI6LTM4LCJyYW5kb20iOjAsImRlZmVuc2l2ZV95YXdfcmFuZG9tX2Zyb20iOjAsImZha2VfeWF3IjowLCJyaWdodF95YXciOjAsImFudGlfYnJ1dGUiOmZhbHNlLCJqaXR0ZXJfZGVsYXkiOjEsImRlZmVuc2l2ZV95YXdfaml0dGVyX3JpZ2h0Ijo5MCwiYm9keV95YXdfdmFsdWUiOjAsInJhbmRvbWl6ZV9qaXR0ZXJfZGVsYXkiOjAsImRlZmVuc2l2ZV9waXRjaF9jdXN0b20iOjAsImRlZmVuc2l2ZV95YXdfcmFuZG9tX3RvIjowLCJyZWFsX3lhdyI6MCwiZGVmZW5zaXZlX3BpdGNoX3N3YXlfdG8iOjE2LCJ5YXdfdHlwZSI6IjE4MCIsImRlZmVuc2l2ZV9waXRjaF9zd2F5X3NoaWZ0IjozLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9jb21ibyI6IlJhbmRvbSIsImRlZmVuc2l2ZV9waXRjaF9yYW5kb21fdG8iOjAsImFsbG93Ijp0cnVlLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9sZWZ0IjotOTAsInlhd19qaXR0ZXJfdmFsdWUiOi01MiwiZGVmZW5zaXZlX3lhd19jdXN0b20iOjAsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfZnJvbSI6LTQ5LCJkZWZlbnNpdmVfeWF3X2NvbWJvIjoiSml0dGVyIiwiZGVmZW5zaXZlX3R5cGUiOiJGbGljayIsImRlZmVuc2l2ZV95YXdfc3Bpbl9zcGVlZCI6MH0sIkdsb2JhbCI6eyJnbG9iYWxfeWF3IjowLCJib2R5X3lhd19jb21ibyI6IkppdHRlciIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfdG8iOjAsImRlZmVuc2l2ZV9waXRjaF9jb21ibyI6IkN1c3RvbSIsImRlZmVuc2l2ZV9jaGVja2JveCI6ZmFsc2UsInlhd19qaXR0ZXJfY29tYm8iOiJPZmYiLCJsZWZ0X3lhdyI6LTM0LCJkZWZlbnNpdmVfcGl0Y2hfcmFuZG9tX2Zyb20iOjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3ZhbHVlIjowLCJkZWZlbnNpdmVfcGl0Y2hfc3dheV9mcm9tIjowLCJyYW5kb20iOjAsImRlZmVuc2l2ZV95YXdfcmFuZG9tX2Zyb20iOjAsImZha2VfeWF3IjowLCJyaWdodF95YXciOjYxLCJhbnRpX2JydXRlIjp0cnVlLCJqaXR0ZXJfZGVsYXkiOjEsImRlZmVuc2l2ZV95YXdfaml0dGVyX3JpZ2h0IjowLCJib2R5X3lhd192YWx1ZSI6NjAsInJhbmRvbWl6ZV9qaXR0ZXJfZGVsYXkiOjEsImRlZmVuc2l2ZV9waXRjaF9jdXN0b20iOjAsImRlZmVuc2l2ZV95YXdfcmFuZG9tX3RvIjowLCJyZWFsX3lhdyI6MCwiZGVmZW5zaXZlX3BpdGNoX3N3YXlfdG8iOjAsInlhd190eXBlIjoiRGVsYXllZCIsImRlZmVuc2l2ZV9waXRjaF9zd2F5X3NoaWZ0IjoxLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9jb21ibyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaF9yYW5kb21fdG8iOjAsImFsbG93IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfbGVmdCI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwiZGVmZW5zaXZlX3lhd19jdXN0b20iOjEsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfZnJvbSI6MCwiZGVmZW5zaXZlX3lhd19jb21ibyI6IkN1c3RvbSIsImRlZmVuc2l2ZV90eXBlIjoiT24gUGVlayIsImRlZmVuc2l2ZV95YXdfc3Bpbl9zcGVlZCI6MH0sIkZha2VMYWciOnsiZmFrZV95YXciOjAsImdsb2JhbF95YXciOjAsImxlZnRfeWF3IjowLCJyYW5kb21pemVfaml0dGVyX2RlbGF5IjowLCJib2R5X3lhd192YWx1ZSI6MCwiYm9keV95YXdfY29tYm8iOiJMZWZ0IiwicmlnaHRfeWF3IjowLCJhbGxvdyI6ZmFsc2UsImppdHRlcl9kZWxheSI6MSwieWF3X2ppdHRlcl92YWx1ZSI6MCwiYW50aV9icnV0ZSI6ZmFsc2UsInJhbmRvbSI6MCwicmVhbF95YXciOjAsInlhd190eXBlIjoiMTgwIiwieWF3X2ppdHRlcl9jb21ibyI6Ik9mZiJ9LCJBaXIiOnsiZ2xvYmFsX3lhdyI6MCwiYm9keV95YXdfY29tYm8iOiJKaXR0ZXIiLCJkZWZlbnNpdmVfcGl0Y2hfaml0dGVyX3RvIjowLCJkZWZlbnNpdmVfcGl0Y2hfY29tYm8iOiJDdXN0b20iLCJkZWZlbnNpdmVfY2hlY2tib3giOmZhbHNlLCJ5YXdfaml0dGVyX2NvbWJvIjoiT2ZmIiwibGVmdF95YXciOjAsImRlZmVuc2l2ZV9waXRjaF9yYW5kb21fZnJvbSI6MCwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfdmFsdWUiOjAsImRlZmVuc2l2ZV9waXRjaF9zd2F5X2Zyb20iOjAsInJhbmRvbSI6MCwiZGVmZW5zaXZlX3lhd19yYW5kb21fZnJvbSI6MCwiZmFrZV95YXciOjAsInJpZ2h0X3lhdyI6MCwiYW50aV9icnV0ZSI6ZmFsc2UsImppdHRlcl9kZWxheSI6MSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfcmlnaHQiOjAsImJvZHlfeWF3X3ZhbHVlIjo2MCwicmFuZG9taXplX2ppdHRlcl9kZWxheSI6MCwiZGVmZW5zaXZlX3BpdGNoX2N1c3RvbSI6MCwiZGVmZW5zaXZlX3lhd19yYW5kb21fdG8iOjAsInJlYWxfeWF3IjowLCJkZWZlbnNpdmVfcGl0Y2hfc3dheV90byI6MCwieWF3X3R5cGUiOiIxODAiLCJkZWZlbnNpdmVfcGl0Y2hfc3dheV9zaGlmdCI6MSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfY29tYm8iOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2hfcmFuZG9tX3RvIjowLCJhbGxvdyI6dHJ1ZSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfbGVmdCI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwiZGVmZW5zaXZlX3lhd19jdXN0b20iOjAsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfZnJvbSI6MCwiZGVmZW5zaXZlX3lhd19jb21ibyI6IkN1c3RvbSIsImRlZmVuc2l2ZV90eXBlIjoiT24gUGVlayIsImRlZmVuc2l2ZV95YXdfc3Bpbl9zcGVlZCI6MH0sIkR1Y2siOnsiZ2xvYmFsX3lhdyI6MCwiYm9keV95YXdfY29tYm8iOiJKaXR0ZXIiLCJkZWZlbnNpdmVfcGl0Y2hfaml0dGVyX3RvIjowLCJkZWZlbnNpdmVfcGl0Y2hfY29tYm8iOiJDdXN0b20iLCJkZWZlbnNpdmVfY2hlY2tib3giOmZhbHNlLCJ5YXdfaml0dGVyX2NvbWJvIjoiT2ZmIiwibGVmdF95YXciOi0yNywiZGVmZW5zaXZlX3BpdGNoX3JhbmRvbV9mcm9tIjowLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl92YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoX3N3YXlfZnJvbSI6MCwicmFuZG9tIjowLCJkZWZlbnNpdmVfeWF3X3JhbmRvbV9mcm9tIjowLCJmYWtlX3lhdyI6MCwicmlnaHRfeWF3IjozNiwiYW50aV9icnV0ZSI6dHJ1ZSwiaml0dGVyX2RlbGF5IjoxLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9yaWdodCI6MCwiYm9keV95YXdfdmFsdWUiOjYwLCJyYW5kb21pemVfaml0dGVyX2RlbGF5IjozLCJkZWZlbnNpdmVfcGl0Y2hfY3VzdG9tIjowLCJkZWZlbnNpdmVfeWF3X3JhbmRvbV90byI6MCwicmVhbF95YXciOjAsImRlZmVuc2l2ZV9waXRjaF9zd2F5X3RvIjowLCJ5YXdfdHlwZSI6IkRlbGF5ZWQiLCJkZWZlbnNpdmVfcGl0Y2hfc3dheV9zaGlmdCI6MSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfY29tYm8iOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2hfcmFuZG9tX3RvIjowLCJhbGxvdyI6dHJ1ZSwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfbGVmdCI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwiZGVmZW5zaXZlX3lhd19jdXN0b20iOjEsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfZnJvbSI6MCwiZGVmZW5zaXZlX3lhd19jb21ibyI6IkN1c3RvbSIsImRlZmVuc2l2ZV90eXBlIjoiT24gUGVlayIsImRlZmVuc2l2ZV95YXdfc3Bpbl9zcGVlZCI6MH19fQ==") end)
local import_button = pui.button("AA", "Fake lag", "Import", function() configs.import() end)
local export_button = pui.button("AA", "Fake lag", "Export", function() configs.export() end)
---@end

---@region Defensive system
local defensive_system = {
    ticks_count = 0,
    max_tick_base = 0,
    is_defensive = false
}

local function defensive_check_stage()
    if debug_elements.defensive_check_type:get() ~= "frame_stage_notify" then
        return
    end

    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    local current_tick = globals.tickcount()
    local tick_base = entity.get_prop(lp, "m_nTickBase") or 0
    local can_exploit = current_tick > tick_base

    if math.abs(tick_base - defensive_system.max_tick_base) > 64 and can_exploit then
        defensive_system.max_tick_base = 0
    end

    if tick_base > defensive_system.max_tick_base then
        defensive_system.max_tick_base = tick_base
    elseif defensive_system.max_tick_base > tick_base then
        defensive_system.ticks_count = can_exploit and math.min(14, math.max(0, defensive_system.max_tick_base - tick_base - 1)) or 0
    end

    defensive_system.is_defensive = (defensive_system.ticks_count > debug_elements.defensive_check_slider1:get() 
        and defensive_system.ticks_count < debug_elements.defensive_check_slider2:get())
end

local function defensive_check_predict(cmd)
    if debug_elements.defensive_check_type:get() ~= "predict_command" then
        return
    end

    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    local current_tick = globals.tickcount()
    local tick_base = entity.get_prop(lp, "m_nTickBase") or 0
    local can_exploit = current_tick > tick_base

    if math.abs(tick_base - defensive_system.max_tick_base) > 64 and can_exploit then
        defensive_system.max_tick_base = 0
    end

    if tick_base > defensive_system.max_tick_base then
        defensive_system.max_tick_base = tick_base
    elseif defensive_system.max_tick_base > tick_base then
        defensive_system.ticks_count = can_exploit and math.min(14, math.max(0, defensive_system.max_tick_base - tick_base - 1)) or 0
    end

    defensive_system.is_defensive = (defensive_system.ticks_count > debug_elements.defensive_check_slider1:get() 
        and defensive_system.ticks_count < debug_elements.defensive_check_slider2:get())
end

---@end

local function is_peeking()
    local me = entity.get_local_player()
    if not me then return end
    local enemies = entity.get_players(true)
    if not enemies then
        return false
    end

    local predict_amt = 0.25
    local eye_position = vector(client.eye_position())
    local velocity_prop_local = vector(entity.get_prop(me, 'm_vecVelocity'))
    local predicted_eye_position = vector(eye_position.x + velocity_prop_local.x * predict_amt, eye_position.y + velocity_prop_local.y * predict_amt, eye_position.z + velocity_prop_local.z * predict_amt)
    for i = 1, #enemies do
        local player = enemies[i]
        local velocity_prop = vector(entity.get_prop(player, 'm_vecVelocity'))
        local origin = vector(entity.get_prop(player, 'm_vecOrigin'))
        local predicted_origin = vector(origin.x + velocity_prop.x * predict_amt, origin.y + velocity_prop.y * predict_amt, origin.z + velocity_prop.z * predict_amt)
        entity.get_prop(player, 'm_vecOrigin', predicted_origin)
        local head_origin = vector(entity.hitbox_position(player, 0))
        local predicted_head_origin = vector(head_origin.x + velocity_prop.x * predict_amt, head_origin.y + velocity_prop.y * predict_amt, head_origin.z + velocity_prop.z * predict_amt)
        local trace_entity, damage = client.trace_bullet(me, predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z)
        entity.get_prop( player, 'm_vecOrigin', origin )
        if damage > 0 then
            return true
        end
    end
    return false
end


local function get_current_player_state()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return "Unknown"
    end

    local velocity = {entity.get_prop(local_player, "m_vecVelocity[0]"), entity.get_prop(local_player, "m_vecVelocity[1]")}
    local flags = entity.get_prop(local_player, "m_fFlags")

    if not velocity[1] or not velocity[2] or not flags then
        return "Unknown"
    end

    local speed = math.sqrt(velocity[1]^2 + velocity[2]^2)

    if ui.get(ref.slow_walk[2]) then
        return "SlowWalk"
    end

    if ui.get(ref.freestand[2]) then
        return "Freestand"
    end

    if not ui.get(ref.dt[2]) and not ui.get(ref.hs[2]) then
        return "FakeLag"
    end

    if ui.get(ref.fd) then
        return "FakeLag"
    end

    if bit.band(flags, 1) == 0 then
        if bit.band(flags, 2) ~= 0 then
            return "Airduck"
        else
            return "Air"
        end
    else
        if speed > 5 then
            if bit.band(flags, 2) ~= 0 then
                return "DuckRun"
            else
                return "Walk"
            end
        else
            if bit.band(flags, 2) ~= 0 then
                return "Duck"
            else
                return "Stand"
            end
        end
    end
end

---@region delay jitter
command_number = 1
is_on_ground = false
local function globals_command_number(cmd)
    command_number = cmd.command_number
    is_on_ground = cmd.in_jump == 0
end

local jitter_switch = false
local delay_timer = 0

local function smoothJitter(switchyaw1, switchyaw2, speed, yawrandom)
    local speed = speed + 1
    local random_value_left = math.random(0, switchyaw1 * yawrandom / 100)
    local random_value_right = math.random(0, switchyaw2 * yawrandom / 100)

    if globals.chokedcommands() == 0 and command_number % 2 >= math.abs(math.sin(globals.chokedcommands())) then
        delay_timer = delay_timer + 1
        if delay_timer % speed == 0 then
            jitter_switch = not jitter_switch
        end
    end

    local finalyawgg = jitter_switch and (switchyaw1 + random_value_left) or (switchyaw2 - random_value_right)
    return tools.clamp(finalyawgg, -180, 180)
end
---@end

---@region sway
local sway_state = {
    current_value = 0,
    increasing = true
}

local function custom_sway(from, to, shift)
    if sway_state.increasing then
        sway_state.current_value = sway_state.current_value + shift
        if sway_state.current_value >= to then
            sway_state.current_value = to
            sway_state.increasing = false
        end
    else
        sway_state.current_value = sway_state.current_value - shift
        if sway_state.current_value <= from then
            sway_state.current_value = from
            sway_state.increasing = true
        end
    end

    return sway_state.current_value
end
---@end

---@region anti-brute
local last_bullet_time = 0
local bullet_nearby = false
local yaw_multiplier = 1
local anti_brute_logged = false
local saved_left_yaw, saved_right_yaw

local function closest_point_on_ray(point, ray_start, ray_end)
    local to_point = point - ray_start
    local ray_dir = (ray_end - ray_start):normalized()
    local projection_length = to_point:dot(ray_dir)
    local projection = ray_dir * math.max(0, math.min(projection_length, (ray_end - ray_start):length()))
    return ray_start + projection
end

local function antibrute(e)
    local me = entity.get_local_player()
    if not me or not entity.is_alive(me) then return end
    
    local ent = client.userid_to_entindex(e.userid)
    if not entity.is_dormant(ent) and entity.is_enemy(ent) then
        local head_pos = vector(entity.hitbox_position(me, 0))
        
        local eye_pos = vector(entity.get_prop(ent, "m_vecOrigin")) + vector(0, 0, 64)
        local impact_pos = vector(e.x, e.y, e.z)
        
        local closest_point = closest_point_on_ray(head_pos, eye_pos, impact_pos)
        local distance = (closest_point - head_pos):length()

        if distance < 180 then
            last_bullet_time = globals.curtime()
            bullet_nearby = true
            yaw_multiplier = math.random(110, 120) / 100
            anti_brute_logged = false
            saved_left_yaw = nil
            saved_right_yaw = nil
        end
    end
end

local function update_bullet_nearby_status()
    if globals.curtime() - last_bullet_time > 2 then
        bullet_nearby = false
        yaw_multiplier = 1
        anti_brute_logged = true
        saved_left_yaw = nil
        saved_right_yaw = nil
    end
end
---@end

---@region Defensive structure
local defensive = {
    pitch = 0,
    yaw = 0,
    fake_lag_last_time = 0,
    yaw_opposite = 0,
    yaw_type = nil
}

local function get_opposite_yaw()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    local yaw = ref.yaw[2]
    if not defensive_system.is_defensive then
        if yaw == 0 then
            defensive.yaw_opposite = -180
        else
            defensive.yaw_opposite = (yaw > 0 and yaw - 180 or yaw + 180)
        end
    end
end
---@end

---@region revolve helper
local function Distance(x1, y1, z1, x2, y2, z2)
    if not x1 or not y1 or not z1 or not x2 or not y2 or not z2 then
        return math.huge
    end
    return math.ceil(math.sqrt((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2))
end

local function is_revolver(weapon)
    return entity.get_prop(weapon, "m_iItemDefinitionIndex") == 64
end

local function check_revolver_distance(player, victim)
    if not player or not victim then return 0 end

    local weapon = entity.get_prop(player, "m_hActiveWeapon")
    if not weapon or not is_revolver(weapon) then return 0 end

    local player_pos = entity.get_origin(player)
    local victim_pos = entity.get_origin(victim)

    if not player_pos or not victim_pos then return 0 end

    local units = Distance(player_pos.x, player_pos.y, player_pos.z, victim_pos.x, victim_pos.y, victim_pos.z)
    local no_kevlar = entity.get_prop(victim, "m_ArmorValue") == 0
    local height_difference = player_pos.z - victim_pos.z

    if height_difference > 100 and units < 300 then
        return "DMG+"
    elseif units > 585 then
        return "DMG-"
    elseif units > 511 then
        return "DMG"
    elseif units <= 511 and no_kevlar then
        return "DMG+"
    elseif units <= 190 then
        return "DMG+"
    else
        return "DMG"
    end
end

local function draw_status(player, status)
    if not misc_elements.revolver_helper:get() then
        return
    end
    local x1, y1, x2, y2, alpha_multiplier = entity.get_bounding_box(player)
    if not x1 or alpha_multiplier == 0 then return end

    local x_center = (x1 + x2) / 2
    local y_position = y1 - 20

    local color = {255, 0, 0}
    if status == "DMG" then
        color = {255, 255, 0}
    elseif status == "DMG+" then
        color = {50, 205, 50}
    end

    renderer.text(x_center, y_position, color[1], color[2], color[3], 255, "cb", 0, status)
end
---@end

---@region DMG indicator
local displayed_min_damage = 0
local function render_damage_indicator()
    if not visuals_elements.damage_indicator:get() then
        return
    end

    local player = entity.get_local_player()
    if not player or not entity.is_alive(player) then
        return
    end

    local screen_x, screen_y = client.screen_size()
    local x = screen_x / 2 + 15
    local y = screen_y / 2 - 11

    local min_damage = ui.get(ref.min_damage)
    if ui.get(ref.min_damage_override[2]) then
        min_damage = ui.get(ref.min_damage_override[3])
    end

    displayed_min_damage = tools.lerp(displayed_min_damage, min_damage, 0.08)
    renderer.text(x, y, 255, 255, 255, 255, "c", nil, string.format("%.0f", displayed_min_damage))
end
---@end

---@region Debug panel
local function get_current_target()
    local target = client.current_threat()
    if target and target ~= -1 then
        return entity.get_player_name(target)
    else
        return "nil"
    end
end

local function get_desync_angle()
    local local_player = entity.get_local_player()
    if not local_player then
        return 0
    end
    local desync_angle = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    return math.abs(math.floor(desync_angle))
end

local function get_current_target()
    local target = client.current_threat()
    if target and target ~= -1 then
        return entity.get_player_name(target)
    else
        return "nil"
    end
end

local function get_desync_angle()
    local local_player = entity.get_local_player()
    if not local_player then
        return 0
    end
    local desync_angle = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    return math.abs(math.floor(desync_angle))
end

local function render_debug_panel()
    if not visuals_elements.debug_panel:get() then
        return
    end

    local player = entity.get_local_player()
    if not player or not entity.is_alive(player) then
        return
    end

    local screen_width, screen_height = client.screen_size()
    local text_x = 13
    local text_y = (screen_height / 2) - 10

    renderer.text(text_x, text_y, 255, 255, 255, 255, "", 0, "excellent")

    renderer.text(text_x, text_y + 15, 255, 255, 255, 255, "", 0, "Username: " .. info.user)

    local target = get_current_target()
    renderer.text(text_x, text_y + 30, 255, 255, 255, 255, "", 0, "Target: " .. target)

    local desync_value = get_desync_angle()
    renderer.text(text_x, text_y + 45, 255, 255, 255, 255, "", 0, "Desync: " .. desync_value)

    renderer.text(text_x, text_y + 60, 255, 255, 255, 255, "", 0, "Defensive: " .. tostring(defensive_system.is_defensive))

    local player_state = get_current_player_state()
    renderer.text(text_x, text_y + 75, 255, 255, 255, 255, "", 0, "Condition: " .. player_state)
end
---@end

---@region Anti backstab
local function anti_stab()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    if not misc_elements.anti_backstab:get() then return end

    local enemies = entity.get_players(true)
    for i = 1, #enemies do 
        local dist = vector(entity.get_origin(enemies[i])):dist2d(vector(entity.get_origin(lp)))
        local enemy_weapon = entity.get_player_weapon(enemies[i])
        if enemy_weapon and entity.get_classname(enemy_weapon) == "CKnife" and dist < 250 then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.yaw[2], 180)
        end 
    end
end
---@end

---@region Hit logs
local hit_logs = {}
local screen_w, screen_h = client.screen_size()
local last_backtrack_ticks = 0
local last_predicted_damage = 0

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local function draw_rect_with_corners(x, y, w, h, bg_r, bg_g, bg_b, alpha, corner_color, corner_alpha)
    renderer.rectangle(x, y, w, h, bg_r, bg_g, bg_b, alpha)
    local corner_length = 10
    renderer.line(x, y, x + corner_length, y, corner_color, corner_color, corner_color, corner_alpha)
    renderer.line(x, y, x, y + corner_length, corner_color, corner_color, corner_color, corner_alpha)
    renderer.line(x + w - corner_length, y, x + w, y, corner_color, corner_color, corner_color, corner_alpha)
    renderer.line(x + w, y, x + w, y + corner_length, corner_color, corner_color, corner_color, corner_alpha)
    renderer.line(x, y + h - corner_length, x, y + h, corner_color, corner_color, corner_color, corner_alpha)
    renderer.line(x, y + h, x + corner_length, y + h, corner_color, corner_color, corner_color, corner_alpha)
    renderer.line(x + w - corner_length, y + h, x + w, y + h, corner_color, corner_color, corner_color, corner_alpha)
    renderer.line(x + w, y + h - corner_length, x + w, y + h, corner_color, corner_color, corner_color, corner_alpha)
end

local function aim_fire(e)
    last_backtrack_ticks = globals.tickcount() - e.tick
    last_predicted_damage = e.damage
end

local function aim_hit(e)
    if not visuals_elements.hit_logs:get(true) then return end
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local remaining_health = entity.get_prop(e.target, "m_iHealth")
    
    local predicted_damage_text = ""
    if last_predicted_damage ~= e.damage then
        predicted_damage_text = string.format(", predicted damage: %d", last_predicted_damage)
    end

    local log_text = string.format(
        "Registered shot in %s's %s for %d damage (hitchance: %d%%, health left: %d, bt: %d%s)",
        entity.get_player_name(e.target), group, e.damage,
        math.floor(e.hit_chance + 0.5), remaining_health, last_backtrack_ticks, predicted_damage_text
    )
    print(log_text)
    table.insert(hit_logs, {
        text = log_text, 
        time = globals.realtime(), 
        state = "appearing", 
        shown_chars = 0, 
        target_y_offset = 0, 
        y_offset = screen_h / 2 + 250, 
        alpha = 255, 
        corner_alpha = 255, 
        text_alpha = 255
    })
end

local function aim_miss(e)
    if not visuals_elements.hit_logs:get(true) then return end
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local log_text = string.format(
        "Missed shot in %s's %s (hitchance: %d%%, bt: %d) due to %s",
        entity.get_player_name(e.target), group,
        math.floor(e.hit_chance + 0.5), last_backtrack_ticks, e.reason
    )
    print(log_text)
    table.insert(hit_logs, {
        text = log_text, 
        time = globals.realtime(), 
        state = "appearing", 
        shown_chars = 0, 
        target_y_offset = 0, 
        y_offset = screen_h / 2 + 250, 
        alpha = 255, 
        corner_alpha = 255, 
        text_alpha = 255
    })
end

local function render_logs()
    if not visuals_elements.hit_logs:get(true) then return end
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        hit_logs = {}
        return
    end
    local current_time = globals.realtime()
    local display_time = 2.0
    local fade_time = 1.33
    local bg_alpha = 120
    local log_height = 30
    local log_spacing = 10

    for i = #hit_logs, 1, -1 do
        local log = hit_logs[i]
        local elapsed = current_time - log.time
        local progress = math.min(elapsed / 0.3, 1)

        if elapsed > display_time then
            log.state = "disappearing"
        end

        if log.state == "appearing" then
            log.alpha = bg_alpha
            log.text_alpha = 255
            log.glow_alpha = 255
            log.shown_chars = math.min(#log.text, math.floor(progress * #log.text))
        elseif log.state == "disappearing" then
            local fade_progress = (elapsed - display_time) / fade_time
            log.glow_alpha = math.max(0, 255 * (1 - fade_progress))
            if fade_progress > 0.5 then
                log.text_alpha = math.max(0, 255 * (1 - (fade_progress - 0.5) * 2))
                log.alpha = math.max(0, bg_alpha * (1 - (fade_progress - 0.5) * 2))
            end
            if log.alpha <= 0 then
                table.remove(hit_logs, i)
            end
        end

        log.target_y_offset = screen_h / 2 + 350 - (i - 1) * (log_height + log_spacing)
        log.y_offset = log.y_offset + (log.target_y_offset - log.y_offset) * 0.1

        local partial_text = string.sub(log.text, 1, log.shown_chars)
        local text_w, text_h = renderer.measure_text("c", partial_text)
        local box_x = (screen_w - text_w) / 2 - 20
        local box_y = log.y_offset
        local box_h = text_h + 12
        local box_w = text_w + 40

        local is_missed = string.find(log.text, "Missed")
        local glow_r, glow_g, glow_b = is_missed and 255 or 0, 0, is_missed and 0 or 255

        for j = 1, 4 do
            local alpha_fade = math.min(log.glow_alpha, (40 / j))
            renderer.rectangle(box_x - j, box_y - j, box_w + j * 2, 1, glow_r, glow_g, glow_b, alpha_fade)
            renderer.rectangle(box_x - j, box_y + box_h + j - 1, box_w + j * 2, 1, glow_r, glow_g, glow_b, alpha_fade)
            renderer.rectangle(box_x - j, box_y, 1, box_h, glow_r, glow_g, glow_b, alpha_fade)
            renderer.rectangle(box_x + box_w + j - 1, box_y, 1, box_h, glow_r, glow_g, glow_b, alpha_fade)
            renderer.circle(box_x - j, box_y - j, glow_r, glow_g, glow_b, alpha_fade)
            renderer.circle(box_x + box_w + j - 1, box_y - j, glow_r, glow_g, glow_b, alpha_fade)
            renderer.circle(box_x - j, box_y + box_h + j - 1, glow_r, glow_g, glow_b, alpha_fade)
            renderer.circle(box_x + box_w + j - 1, box_y + box_h + j - 1, glow_r, glow_g, glow_b, alpha_fade)
        end
        

        renderer.rectangle(box_x, box_y, box_w, box_h, 0, 0, 0, log.alpha)
        renderer.text(box_x + 20, box_y + 6, 255, 255, 255, log.text_alpha, "", 0, partial_text)
    end
end

---@end

---@region center indicator
local alpha = 255
local fade_in = true
local hold_timer = 0
local current_x_offset = 0
local dt_alpha = 0

local letters = "excellent"
local non_space_indices = {}
for i = 1, #letters do
    if letters:sub(i, i) ~= " " and letters:sub(i, i) ~= "." then
        table.insert(non_space_indices, i)
    end
end
local current_letter_index = 1
local letter_timer = 0
local letter_interval = 0.4

local function center_indicator()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) or not visuals_elements.centered_indicators:get() then
        return
    end

    local target_x_offset = entity.get_prop(lp, "m_bIsScoped") == 1 and 27 or 0
    current_x_offset = tools.lerp(current_x_offset, target_x_offset, 0.1)

    local screen_width, screen_height = client.screen_size()
    local x, y = screen_width / 2 + 10, screen_height / 2 + 30

    local full_text = "excellent"
    local total_width = 0
    local letter_widths = {}
    for i = 1, #full_text do
        local char = full_text:sub(i, i)
        local width = renderer.measure_text("c-", char)
        table.insert(letter_widths, width)
        total_width = total_width + width
    end

    local start_x = x - (total_width) / 2 + current_x_offset + 3 - 8

    for i = 1, #full_text do
        local char = full_text:sub(i, i)
        local char_x = start_x
        for j = 1, i - 1 do
            char_x = char_x + letter_widths[j]
        end

        local y_pos = y
        if letters:sub(i, i) ~= " " and i == non_space_indices[current_letter_index] then
            local progress = letter_timer / letter_interval
            if progress > 1 then
                progress = 1
            end
            y_pos = y + math.sin(progress * math.pi) * -2.86
        end

        local r, g, b, a = 255, 255, 255, 255
        if letters:sub(i, i) ~= " " and i == non_space_indices[current_letter_index] then
            r, g, b, a = 150, 150, 150, 255
        end
        renderer.text(char_x - 0.33, y_pos, r, g, b, a, "c-", 0, char)
    end

    local player_state = get_current_player_state()
    local state_text = {
        Stand = "-STANDING-",
        Walk = "-MOVING-",
        FakeLag = "-FAKELAG-",
        Air = "-IN AIR-",
        Airduck = "-CROUCH IN AIR-",
        Duck = "-CROUCH-",
        DuckRun = "-CROUCH RUN-",
        SlowWalk = "-SLOWWALK-"
    }
    renderer.text(x - 10 + current_x_offset + 3, y + 10, 255, 255, 255, 255, "c-", 0, state_text[player_state] or "-UNKNOWN-")

    if not ui.get(ref.dt[2]) then
        dt_alpha = tools.lerp(dt_alpha, 0, 0.08)
    elseif ui.get(ref.dt[2]) and exploit_data.charged then
        dt_alpha = tools.lerp(dt_alpha, 255, 0.08)
    elseif ui.get(ref.dt[2]) and not exploit_data.charged then
        dt_alpha = tools.lerp(dt_alpha, 125, 0.08)
    end

    renderer.text(x - 10 + current_x_offset + 3, y + 20, 255, 255, 255, dt_alpha, "c-", 0, "DT")

    letter_timer = letter_timer + globals.frametime()
    if letter_timer >= letter_interval then
        letter_timer = 0
        current_letter_index = current_letter_index + 1
        if current_letter_index > #non_space_indices then
            current_letter_index = 1
        end
    end

    if fade_in then
        alpha = alpha - 1.5
        if alpha <= 0 then
            fade_in = false
            alpha = 0
        end
    else
        if alpha >= 255 then
            hold_timer = hold_timer + globals.frametime()
            if hold_timer >= 1 then
                fade_in = true
                hold_timer = 0
            end
        else
            alpha = alpha + 1.5
        end
    end
end
---@end

---@region Warmup
local function warmup()
    if entity.get_local_player() == nil then return end

    gamerulesproxy = entity.get_all("CCSGameRulesProxy")[1]
    is_warmup = entity.get_prop(gamerulesproxy,"m_bWarmupPeriod")
  
    if misc_elements.warmup_aa:get() and is_warmup == 1 then
        ui.set(ref.body_yaw[1], 'Off')
        ui.set(ref.yaw[1], "Spin")
        ui.set(ref.yaw[2], 15)
        ui.set(ref.pitch[1], "Custom")
        ui.set(ref.pitch[2], 0)
    end
end
---@end

---@ETO TAK nada
local yaw_direction = 0
local last_press_t_dir = 0
---meow

---@region Freestanding
local function freestanding()
    local lp = entity.get_local_player()
    if not lp then return end


    local current_state = get_current_player_state()
    local disabler_states = misc_elements.freestand_disabler:get()
    local disable_freestand = false

    for _, st in ipairs(disabler_states) do
        if st == current_state then
            disable_freestand = true
            break
        end
    end

    if disable_freestand or not misc_elements.freestand:get() or defensive_system.is_defensive == true or yaw_direction ~= 0 then
        ui.set(ref.freestand[1], false)
        ui.set(ref.freestand[2], "On hotkey")
    else
        ui.set(ref.freestand[1], true)
        ui.set(ref.freestand[2], "Always on")
    end
end
---@end

local yawDirectionMapping = {
    { keyFunc = function() return misc_elements.manual_right_bind:get() end, value = 90 },
    { keyFunc = function() return misc_elements.manual_left_bind:get() end, value = -90 },
    { keyFunc = function() return misc_elements.manual_forward_bind:get() end, value = 180 },
}

---@region manual epta
local function manual_yaw()
    local curtime = globals.curtime()
    
    for _, mapping in ipairs(yawDirectionMapping) do
        if mapping.keyFunc() and (last_press_t_dir + 0.13 < curtime) then
            yaw_direction = (yaw_direction == mapping.value) and 0 or mapping.value
            last_press_t_dir = curtime
            break
        end
    end

    if last_press_t_dir > curtime then
        last_press_t_dir = curtime
    end

    if yaw_direction ~= 0 then
        ui.set(ref.yaw_base, "Local view")
        ui.set(ref.yaw[1], "180")
        ui.set(ref.yaw[2], yaw_direction)
        ui.set(ref.yaw_jitter[1], "Off")
    end
end
---@end

---@region Safe head
local function safehead(cmd)
    if not misc_elements.safe_head:get() then
        return
    end
    local player = entity.get_local_player()
    if not player or not entity.is_alive(player) then
        return
    end

    local state = get_current_player_state()
    if state == "Airduck" then
        local active_weapon = entity.get_prop(player, "m_hActiveWeapon")
        if active_weapon and entity.get_classname(active_weapon) == "CKnife" then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.yaw[2], 0)
            ui.set(ref.body_yaw[2], 60)
            ui.set(ref.pitch[2], 89)
            ui.set(ref.yaw_jitter[1], "Off")
        end
    end
end
---@end

---@region Fast Ladder
local function fast_ladder_setup(cmd)
    local local_player = entity.get_local_player()
    if not local_player then return end

    local pitch, yaw = client.camera_angles()
    if entity.get_prop(local_player, "m_MoveType") == 9 then
        cmd.yaw = math.floor(cmd.yaw + 0.5)
        cmd.roll = 0

        if misc_elements.fast_ladder:get() then
            if cmd.forwardmove > 0 then
                if pitch < 45 then
                    cmd.pitch = 89
                    cmd.in_moveright = 1
                    cmd.in_moveleft = 0
                    cmd.in_forward = 0
                    cmd.in_back = 1
                    if cmd.sidemove == 0 then
                        cmd.yaw = cmd.yaw + 90
                    elseif cmd.sidemove < 0 then
                        cmd.yaw = cmd.yaw + 150
                    else
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
                elseif cmd.sidemove > 0 then
                    cmd.yaw = cmd.yaw + 150
                else
                    cmd.yaw = cmd.yaw + 30
                end
            end
        end
    end
end
---@end

---@region update_dt_charge
local function update_dt_charge(cmd)
    local dt_on = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
    local shiftedTicks = dt_on and 100 or 0

    if not dt_on then
        exploit_data.shift = 0
        exploit_data.charged = false
        exploit_data.update = true
    elseif not exploit_data.charged then
        exploit_data.shift = shiftedTicks
        if shiftedTicks >= 100 then
            exploit_data.shift = 100
            exploit_data.charged = true
            exploit_data.update = false
        end
    end

    if cmd.in_attack == 1 then
        exploit_data.manual_shot = globals.curtime()
    end

    if (exploit_data.shot + 0.5 > globals.curtime()) or (exploit_data.manual_shot + 0.5 > globals.curtime()) then
        exploit_data.shift = 0
        exploit_data.charged = false
        exploit_data.update = true
    end
end
---@end
local del = nil

get_freestand_direction = function()
    local data = {
        side = 1,
        last_side = 0,
        last_hit = 0,
        hit_side = 0
    }

    p = entity.get_local_player()

    if not p or entity.get_prop(p, 'm_lifeState') ~= 0 then
        return
    end

    if data.hit_side ~= 0 and globals.curtime() - data.last_hit > 5 then
        data.last_side = 0
        data.last_hit = 0
        data.hit_side = 0
    end

    local eye = vector(client.eye_position())
    local ang = vector(client.camera_angles())
    local trace_data = {left = 0, right = 0}

    for i = ang.y - 120, ang.y + 120, 30 do
        if i ~= ang.y then
            local rad = math.rad(i)
            local px, py, pz = eye.x + 256 * math.cos(rad), eye.y + 256 * math.sin(rad), eye.z
            local fraction = client.trace_line(p, eye.x, eye.y, eye.z, px, py, pz)
            local side = i < ang.y and 'left' or 'right'
            trace_data[side] = trace_data[side] + fraction
        end
    end

    data.side = trace_data.left < trace_data.right and -1 or 1

    if data.side == data.last_side then
        return
    end

    data.last_side = data.side

    if data.hit_side ~= 0 then
        data.side = data.hit_side
    end

    return data.side
end

normalize = function (x, min, max)
    local delta = max - min;

    while x < min do
        x = x + delta;
    end

    while x > max do
        x = x - delta;
    end

    return x;
end

normalize_yaw = function (x)
    return normalize(x, -180, 180);
end


---@region handle_aa
local function handle_aa(cmd)
    ui.set(ref.yaw_base, "At Targets")
    get_opposite_yaw()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    -- handle fakelag
    ui.set(ref.fake_lag_enabled[1], fake_lag_switch:get())
    ui.set(ref.fake_lag_enabled[2], "Always On")

    if fake_lag_combo:get() == "Cycle" then
        fake_lag_counter = (fake_lag_counter or 8) + 0.33
        if fake_lag_counter > fake_lag_slider:get() + 1 then
            fake_lag_counter = 8
        end
        ui.set(ref.fake_lag_amount, "Maximum")
        ui.set(ref.fake_lag_limit, fake_lag_counter)
    elseif fake_lag_combo:get() == "Maximum" then
        ui.set(ref.fake_lag_amount, "Maximum")
        ui.set(ref.fake_lag_limit, fake_lag_slider:get())
    elseif fake_lag_combo:get() == "Fluctuate" then
        ui.set(ref.fake_lag_amount, "Fluctuate")
        ui.set(ref.fake_lag_limit, fake_lag_slider:get())
    end

    ui.set(ref.pitch[1], "Minimal")
    ui.set(ref.yaw[1], "180")
    ui.set(ref.yaw_jitter[1], "Off")

    local current_state = get_current_player_state()
    local settings = state_settings[current_state]

    if not settings or (current_state ~= "Global" and not settings.allow:get()) then
        settings = state_settings["Global"]
    end

    if settings then
        local body_yaw_setting = settings.body_yaw_combo:get()
        local yaw_type = settings.yaw_type:get()
        local global_yaw_value = settings.global_yaw:get()
        local left_yaw_value = settings.left_yaw:get()
        local right_yaw_value = settings.right_yaw:get()
        local jitter_delay = settings.jitter_delay:get()
        del = jitter_delay + 1
        local randomize_jitter_delay = settings.randomize_jitter_delay:get()
        local body_value = settings.body_yaw_value:get()
        local yawrandom = settings.random:get()
        local jitter_type = settings.yaw_jitter_combo:get()
        local jitter_value = settings.yaw_jitter_value:get()
        local anti_brute = settings.anti_brute:get()
        local real_yaw = settings.real_yaw:get()
        local fake_yaw = settings.fake_yaw:get()

        ui.set(ref.yaw_jitter[1], jitter_type)
        ui.set(ref.yaw_jitter[2], jitter_value)

        -- Jitter + Delayed
        if body_yaw_setting == "Jitter" and yaw_type == "Delayed" then
            if bullet_nearby and anti_brute then
                if not saved_left_yaw or not saved_right_yaw then
                    saved_left_yaw = left_yaw_value * yaw_multiplier
                    saved_right_yaw = right_yaw_value * yaw_multiplier
                end

                if not anti_brute_logged then
                    print(string.format("Clever AA activated. Generated values - Left Yaw: %d, Right Yaw: %d",
                        math.floor(saved_left_yaw), math.floor(saved_right_yaw)))
                    anti_brute_logged = true
                end

                local yaw_jitter = tools.clamp(smoothJitter(saved_left_yaw, saved_right_yaw, jitter_delay + math.random(0, randomize_jitter_delay), yawrandom), -180, 180)
                ui.set(ref.yaw[2], yaw_jitter)
                ui.set(ref.body_yaw[1], "Static")
                local body_yaw_value = smoothJitter(-body_value * yaw_multiplier, body_value * yaw_multiplier, jitter_delay + math.random(0, randomize_jitter_delay), 0)
                ui.set(ref.body_yaw[2], body_yaw_value)
            else
                local yaw_jitter = tools.clamp(smoothJitter(left_yaw_value, right_yaw_value, jitter_delay + math.random(0, randomize_jitter_delay), yawrandom), -180, 180)
                ui.set(ref.yaw[2], yaw_jitter)
                ui.set(ref.body_yaw[1], "Static")
                local body_yaw_value = smoothJitter(-body_value, body_value, jitter_delay + math.random(0, randomize_jitter_delay), 0)
                ui.set(ref.body_yaw[2], body_yaw_value)
            end

        else
            if body_yaw_setting == "Left" and yaw_type == "Delayed" then
                local yaw_value = tools.clamp(left_yaw_value, -180, 180)
                ui.set(ref.yaw[2], yaw_value)
                ui.set(ref.body_yaw[1], "Static")
                ui.set(ref.body_yaw[2], -body_value)

            elseif body_yaw_setting == "Right" and yaw_type == "Delayed" then
                local yaw_value = tools.clamp(right_yaw_value, -180, 180)
                ui.set(ref.yaw[2], yaw_value)
                ui.set(ref.body_yaw[1], "Static")
                ui.set(ref.body_yaw[2], body_value)

            elseif body_yaw_setting == "Left" and yaw_type == "180" then
                local yaw_value = tools.clamp(global_yaw_value, -180, 180)
                ui.set(ref.yaw[2], yaw_value)
                ui.set(ref.body_yaw[1], "Static")
                ui.set(ref.body_yaw[2], -body_value)

            elseif body_yaw_setting == "Right" and yaw_type == "180" then
                local yaw_value = tools.clamp(global_yaw_value, -180, 180)
                ui.set(ref.yaw[2], yaw_value)
                ui.set(ref.body_yaw[1], "Static")
                ui.set(ref.body_yaw[2], body_value)

            elseif body_yaw_setting == "Jitter" and (yaw_type == "180" or yaw_type == "fake") then
                ui.set(ref.yaw[2], global_yaw_value)
                ui.set(ref.body_yaw[1], "Jitter")
                ui.set(ref.body_yaw[2], body_value)
            end
        end

        if yaw_type == "Fake" then
            ui.set(ref.body_yaw[1], "Static")
            ui.set(ref.body_yaw[2], get_current_player_state() == "FakeLag" and -fake_yaw or 0)
            local can_fake = false
            local tick = globals.tickcount() % 6
        
            if globals.chokedcommands() > 0 then
                cmd.allow_send_packet = true
                can_fake = true
                ui.set(ref.yaw[1], "180")
                if tick == 0 then
                    ui.set(ref.yaw[2], tools.clamp(real_yaw + 2, -180, 180))
                else
                    ui.set(ref.yaw[2], tools.clamp(real_yaw - 1, -180, 180))
                end
            else
                cmd.allow_send_packet = false
                can_fake = false
                ui.set(ref.yaw[1], "180")
                if tick == 0 then
                    ui.set(ref.yaw[2], tools.clamp(fake_yaw + 1, -180, 180))
                else
                    ui.set(ref.yaw[2], tools.clamp(fake_yaw - 1, -180, 180))
                end
            end
        end

        if current_state ~= "FakeLag" then
            local current_time = globals.curtime()
            local defensive_box = settings.defensive_checkbox and settings.defensive_checkbox:get()
            if defensive_box then
                local defensive_mode = settings.defensive_type:get()
                local defensive_pitch = settings.defensive_pitch_combo:get()
                local defensive_yaw = settings.defensive_yaw_combo:get()
                local defensive_pitch_custom = settings.defensive_pitch_custom:get()
                local defensive_yaw_custom = settings.defensive_yaw_custom:get()

                local defensive_pitch_sway_from = settings.defensive_pitch_sway_from:get()
                local defensive_pitch_sway_to = settings.defensive_pitch_sway_to:get()
                local defensive_pitch_sway_shift = settings.defensive_pitch_sway_shift:get()
                local defensive_pitch_jitter_from = settings.defensive_pitch_jitter_from:get()
                local defensive_pitch_jitter_to = settings.defensive_pitch_jitter_to:get()
                local defensive_pitch_random_from = settings.defensive_pitch_random_from:get()
                local defensive_pitch_random_to = settings.defensive_pitch_random_to:get()

                local defensive_yaw_spin_speed = settings.defensive_yaw_spin_speed:get()
                local defensive_yaw_random_from = settings.defensive_yaw_random_from:get()
                local defensive_yaw_random_to = settings.defensive_yaw_random_to:get()
                local defensive_yaw_jitter_left = settings.defensive_yaw_jitter_left:get()
                local defensive_yaw_jitter_right = settings.defensive_yaw_jitter_right:get()
                local defensive_yaw_jitter_combo = settings.defensive_yaw_jitter_combo:get()
                local defensive_yaw_jitter_value = settings.defensive_yaw_jitter_value:get()

                if defensive_mode == "Always On" then
                    cmd.force_defensive = 1
                elseif defensive_mode == "On Peek" and is_peeking() then
                    cmd.force_defensive = 1
                    cmd.allow_send_packet = false
                elseif defensive_mode == "Flick" then
                    cmd.force_defensive = globals.commandack() % math.random(3, 4) == 1
                end

                if defensive_pitch == "Custom" then
                    defensive.pitch = defensive_pitch_custom
                elseif defensive_pitch == "Sway" then
                    defensive.pitch = custom_sway(defensive_pitch_sway_from, defensive_pitch_sway_to, defensive_pitch_sway_shift)
                elseif defensive_pitch == "Jitter" then
                    defensive.pitch = smoothJitter(defensive_pitch_jitter_from, defensive_pitch_jitter_to, (settings.jitter_delay and settings.jitter_delay:get()) or 1, 0)
                elseif defensive_pitch == "Random" then
                    defensive.pitch = math.random(defensive_pitch_random_from, defensive_pitch_random_to)
                end

                if current_state == "Freestand" and defensive_yaw == "Custom" then
                    if is_peeking() then
                    defensive.yaw_type = "180"
                    defensive.yaw = normalize_yaw(get_freestand_direction() * defensive_yaw_custom)
                    end
                elseif defensive_yaw == "Custom" then
                    defensive.yaw = defensive_yaw_custom
                    defensive.yaw_type = "180"
                elseif defensive_yaw == "Spin" then
                    defensive.yaw_type = "Spin"
                    defensive.yaw = defensive_yaw_spin_speed
                elseif defensive_yaw == "Random" then
                    defensive.yaw = math.random(defensive_yaw_random_from, defensive_yaw_random_to)
                    defensive.yaw_type = "180"
                elseif defensive_yaw == "Jitter" then
                    defensive.yaw = smoothJitter(defensive_yaw_jitter_left, defensive_yaw_jitter_right, del, 0)
                    defensive.yaw_type = "180"
                elseif defensive_yaw == "Opposite" then
                    defensive.yaw = defensive.yaw_opposite
                    defensive.yaw_type = "180"
                elseif defensive_yaw == "Jitter v2" then
                    defensive.yaw = smoothJitter(defensive_yaw_jitter_left, defensive_yaw_jitter_right, del, 0)
                    defensive.yaw_type = "180"
                end
                
                

                if defensive_system.is_defensive == true and (current_time - defensive.fake_lag_last_time) > 0.54 then
                    ui.set(ref.pitch[1], "Custom")
                    ui.set(ref.pitch[2], defensive.pitch)
                    ui.set(ref.yaw[1], defensive.yaw_type)
                    ui.set(ref.yaw[2], defensive.yaw)
                    ui.set(ref.yaw_jitter[1], defensive_yaw_jitter_combo)
                    ui.set(ref.yaw_jitter[2], defensive_yaw_jitter_value)

                    if defensive_yaw == "Jitter v2" then
                        ui.set(ref.body_yaw[1], "Static")
                        ui.set(ref.body_yaw[2], smoothJitter(-60, 60, del, 0))
                    else
                        ui.set(ref.body_yaw[1], "Opposite")
                    end
                end
            end
        end
    end
end
---@end

---@region Session time
local previous_time = client.unix_time()
local session_time = 0
local session_minute = 0

local function get_session_time()
    local current_unix_time = client.unix_time()
    local elapsed_time = current_unix_time - previous_time

    if elapsed_time > 0 then
        session_time = session_time + elapsed_time
        previous_time = current_unix_time

        while session_time >= 60 do
            session_minute = session_minute + 1
            session_time = session_time - 60
        end
    end
    info_elements.session_time:set("Session time : ".. session_minute .. " min ".. session_time.. " sec")
end
---@end

---@region animfix

local function animfix_setup()
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()


    if not self_anim_state then
        return
    end

    if visuals_elements.animfix:get("Body lean") == true then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end
        local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 then
            self_anim_overlay.weight = 1
        end
    end

    if visuals_elements.animfix:get("Jitter legs") == true then

        ui.set(ui.reference("AA", "other", "leg movement"), command_number % 3 == 0 and "Off" or "Always slide")
        entity.set_prop(self, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 5 / 10 or 1)

    end

    if visuals_elements.animfix:get("0 pitch on landing") == true then
        if not self_anim_state.hit_in_ground_animation or not is_on_ground then
            return
        end

        entity.set_prop(self, "m_flPoseParameter", 0.5, 12)

    end
end
---@region end


---@region manual indicators
local transition_progress = 1
local last_yaw_direction = 0
local indicator_alpha = 0
local indicator_offset = 60
local scope_offset = 0

---@region manual indicators
local function render_manual()
    local screenW, screenH = client.screen_size()
    local centerX, centerY = screenW / 2, screenH / 2
    local lp = entity.get_local_player()
    local isScoped = lp and (entity.get_prop(lp, "m_bIsScoped") == 1)

    if yaw_direction ~= last_yaw_direction then
        transition_progress = math.max(transition_progress - 0.1, 0)
        if transition_progress == 0 then
            last_yaw_direction = yaw_direction
        end
    else
        if transition_progress < 1 then
            transition_progress = math.min(transition_progress + 0.1, 1)
        end
    end

    local alpha = 255 * transition_progress
    if alpha < 1 then return end
    local base_offset = (last_yaw_direction ~= 0) and 60 or 40
    local animated_offset = base_offset * transition_progress
    local target_scope_offset = ((last_yaw_direction == -90 or last_yaw_direction == 90) and isScoped) and 30 or 0
    scope_offset = tools.lerp(scope_offset, target_scope_offset, 0.1)
    local animated_scope_offset = scope_offset * transition_progress

    local r, g, b, a = 255, 255, 255, alpha
    local fill_alpha = a / 3.82
    local arrowWidth, arrowHeight = 20, 20

    if last_yaw_direction == -90 then
        local cx = centerX - animated_offset
        local cy = centerY - animated_scope_offset
        local tipX = cx - arrowWidth / 2
        local tipY = cy
        local topX = cx + arrowWidth / 2
        local topY = cy - arrowHeight / 2
        local bottomX = cx + arrowWidth / 2
        local bottomY = cy + arrowHeight / 2

        renderer.triangle(tipX, tipY, topX, topY, bottomX, bottomY, r, g, b, fill_alpha)
        renderer.line(tipX, tipY, topX, topY, r, g, b, a)
        renderer.line(topX, topY, bottomX, bottomY, r, g, b, a)
        renderer.line(bottomX, bottomY, tipX, tipY, r, g, b, a)
    elseif last_yaw_direction == 90 then
        local cx = centerX + animated_offset
        local cy = centerY - animated_scope_offset
        local tipX = cx + arrowWidth / 2
        local tipY = cy
        local topX = cx - arrowWidth / 2
        local topY = cy - arrowHeight / 2
        local bottomX = cx - arrowWidth / 2
        local bottomY = cy + arrowHeight / 2

        renderer.triangle(tipX, tipY, topX, topY, bottomX, bottomY, r, g, b, fill_alpha)
        renderer.line(tipX, tipY, topX, topY, r, g, b, a)
        renderer.line(topX, topY, bottomX, bottomY, r, g, b, a)
        renderer.line(bottomX, bottomY, tipX, tipY, r, g, b, a)
    elseif last_yaw_direction == 180 then
        local cx = centerX
        local cy = centerY - animated_offset
        local tipX = cx
        local tipY = cy - arrowHeight / 2
        local leftX = cx - arrowWidth / 2
        local leftY = cy + arrowHeight / 2
        local rightX = cx + arrowWidth / 2
        local rightY = cy + arrowHeight / 2

        renderer.triangle(tipX, tipY, leftX, leftY, rightX, rightY, r, g, b, fill_alpha)
        renderer.line(tipX, tipY, leftX, leftY, r, g, b, a)
        renderer.line(leftX, leftY, rightX, rightY, r, g, b, a)
        renderer.line(rightX, rightY, tipX, tipY, r, g, b, a)
    end
end
---@end

---@region Render text bottom
local function render_gradient_text()
    local text = "excellent"
    local screen_w, screen_h = client.screen_size()
    local total_w, total_h = renderer.measure_text("l", text)
    local start_x = (screen_w / 2) - (total_w / 2)
    local y = screen_h - 20 + 3
    local white = {255, 255, 255}
    local metal = {192, 192, 192}
    local t = globals.realtime()
    local speed = 1.3
    local offset = (t * speed) % 1
    local current_x = start_x
    for i = 1, #text do
        local letter = text:sub(i, i)
        local letter_w, letter_h = renderer.measure_text("l", letter)
        local letter_center = (current_x - start_x) + (letter_w / 2)
        local factor = ((letter_center / total_w) + offset) % 1
        local r = white[1] * (1 - factor) + metal[1] * factor
        local g = white[2] * (1 - factor) + metal[2] * factor
        local b = white[3] * (1 - factor) + metal[3] * factor
        renderer.text(current_x, y, math.floor(r), math.floor(g), math.floor(b), 255, "l", 0, letter)
        current_x = current_x + letter_w
    end
end
---@endregion

---@region Show/Hide references
local function on_load()
    local hidden_refs = {
        ref.enabled, ref.pitch[1], ref.pitch[2], ref.yaw_base, ref.yaw[1], ref.yaw[2],
        ref.yaw_jitter[1], ref.yaw_jitter[2], ref.body_yaw[1], ref.body_yaw[2],
        ref.freestanding_body_yaw, ref.edge_yaw, ref.freestand[1], ref.freestand[2],
        ref.roll, ref.fake_lag_enabled[1], ref.fake_lag_enabled[2],
        ref.fake_lag_variance, ref.fake_lag_limit, ref.fake_lag_amount
    }
    for _, ref_item in ipairs(hidden_refs) do
        ui.set_visible(ref_item, false)
    end
end

local function on_unload()
    local visible_refs = {
        ref.enabled, ref.pitch[1], ref.pitch[2], ref.yaw_base, ref.yaw[1], ref.yaw[2],
        ref.yaw_jitter[1], ref.yaw_jitter[2], ref.body_yaw[1], ref.body_yaw[2],
        ref.freestanding_body_yaw, ref.edge_yaw, ref.freestand[1], ref.freestand[2],
        ref.roll, ref.fake_lag_enabled[1], ref.fake_lag_enabled[2],
        ref.fake_lag_variance, ref.fake_lag_limit, ref.fake_lag_amount
    }
    for _, ref_item in ipairs(visible_refs) do
        ui.set_visible(ref_item, true)
    end
end
---@endregion

---@region Visibility
local function update_defensive_visibility(elements, is_current_state, defensive_enabled)
    elements.defensive_pitch_combo:set_visible(is_current_state and defensive_enabled)
    elements.defensive_yaw_combo:set_visible(is_current_state and defensive_enabled)
    elements.defensive_type:set_visible(is_current_state and defensive_enabled)

    local defensive_pitch_selected = elements.defensive_pitch_combo and elements.defensive_pitch_combo:get()
    elements.defensive_pitch_custom:set_visible(is_current_state and defensive_enabled and defensive_pitch_selected == "Custom")
    elements.defensive_pitch_sway_from:set_visible(is_current_state and defensive_enabled and defensive_pitch_selected == "Sway")
    elements.defensive_pitch_sway_to:set_visible(is_current_state and defensive_enabled and defensive_pitch_selected == "Sway")
    elements.defensive_pitch_sway_shift:set_visible(is_current_state and defensive_enabled and defensive_pitch_selected == "Sway")
    elements.defensive_pitch_jitter_from:set_visible(is_current_state and defensive_enabled and defensive_pitch_selected == "Jitter")
    elements.defensive_pitch_jitter_to:set_visible(is_current_state and defensive_enabled and defensive_pitch_selected == "Jitter")
    
    elements.defensive_pitch_random_from:set_visible(is_current_state and defensive_enabled and defensive_pitch_selected == "Random")
    elements.defensive_pitch_random_to:set_visible(is_current_state and defensive_enabled and defensive_pitch_selected == "Random")

    local defensive_yaw_selected = elements.defensive_yaw_combo and elements.defensive_yaw_combo:get()
    elements.defensive_yaw_custom:set_visible(is_current_state and defensive_enabled and defensive_yaw_selected == "Custom")
    elements.defensive_yaw_jitter_left:set_visible(is_current_state and defensive_enabled and (defensive_yaw_selected == "Jitter" or defensive_yaw_selected == "Jitter v2"))
    elements.defensive_yaw_jitter_right:set_visible(is_current_state and defensive_enabled and (defensive_yaw_selected == "Jitter" or defensive_yaw_selected == "Jitter v2"))
    elements.defensive_yaw_spin_speed:set_visible(is_current_state and defensive_enabled and defensive_yaw_selected == "Spin")
    elements.defensive_yaw_random_from:set_visible(is_current_state and defensive_enabled and defensive_yaw_selected == "Random")
    elements.defensive_yaw_random_to:set_visible(is_current_state and defensive_enabled and defensive_yaw_selected == "Random")

    elements.defensive_yaw_jitter_combo:set_visible(is_current_state and defensive_enabled)
    local defensive_yaw_jitter_active = elements.defensive_yaw_jitter_combo and elements.defensive_yaw_jitter_combo:get() ~= "Off"
    elements.defensive_yaw_jitter_value:set_visible(is_current_state and defensive_enabled and defensive_yaw_jitter_active)
end

local function set_visibility(st)
    for _, state_name in ipairs(state) do
        local is_current_state = state_name == st
        local elements = state_settings[state_name]
        
        if elements then
            local allow_state_visible = (state_name == "Global") or elements.allow:get()

            if elements.allow and state_name ~= "Global" then
                elements.allow:set_visible(is_current_state)
            end

            if allow_state_visible then
                if elements.yaw_type then
                    elements.yaw_type:set_visible(is_current_state)
                    local yaw_type = elements.yaw_type:get()
                    elements.global_yaw:set_visible(is_current_state and yaw_type == "180")
                    elements.left_yaw:set_visible(is_current_state and yaw_type == "Delayed")
                    elements.right_yaw:set_visible(is_current_state and yaw_type == "Delayed")
                    elements.fake_yaw:set_visible(is_current_state and yaw_type == "Fake")
                    elements.real_yaw:set_visible(is_current_state and yaw_type == "Fake")
                end

                if elements.random then
                    local yaw_type = elements.yaw_type:get()
                    elements.random:set_visible(is_current_state and elements.body_yaw_combo:get() == "Jitter" and  yaw_type == "Delayed")
                end
                if elements.body_yaw_combo then
                    local yaw_type = elements.yaw_type:get()
                    elements.body_yaw_combo:set_visible(is_current_state and yaw_type ~= "Fake")
                end
                if elements.body_yaw_value then
                    local yaw_type = elements.yaw_type:get()
                    elements.body_yaw_value:set_visible(is_current_state and yaw_type ~= "Fake")
                end
                if elements.jitter_delay then
                    local yaw_type = elements.yaw_type:get()
                    elements.jitter_delay:set_visible(is_current_state and elements.body_yaw_combo:get() == "Jitter" and yaw_type == "Delayed")
                end
                
                if elements.randomize_jitter_delay then
                    local yaw_type = elements.yaw_type:get()
                    elements.randomize_jitter_delay:set_visible(is_current_state and elements.body_yaw_combo:get() == "Jitter" and yaw_type == "Delayed")
                end

                if elements.yaw_jitter_combo then
                    elements.yaw_jitter_combo:set_visible(is_current_state)
                end
                if elements.anti_brute then
                    local yaw_type = elements.yaw_type:get()
                    elements.anti_brute:set_visible(is_current_state and elements.body_yaw_combo:get() == "Jitter" and yaw_type == "Delayed")
                end

                if elements.yaw_jitter_combo and elements.yaw_jitter_value then
                    local is_yaw_jitter_active = elements.yaw_jitter_combo:get() ~= "Off"
                    elements.yaw_jitter_value:set_visible(is_current_state and is_yaw_jitter_active)
                end

                if elements.defensive_checkbox then
                    elements.defensive_checkbox:set_visible(is_current_state)
                    local defensive_enabled = elements.defensive_checkbox:get()
                    update_defensive_visibility(elements, is_current_state, defensive_enabled)
                end
            else
                for key, elem in pairs(elements) do
                    if key ~= "allow" then
                        elem:set_visible(false)
                    end
                end
            end
        end
    end
end

local function hide_all_elements()
    for _, st in ipairs(state) do
        local elements = state_settings[st]
        if elements then
            for _, elem in pairs(elements) do
                elem:set_visible(false)
            end
        end
    end

    for _, elem in pairs(visuals_elements) do
        elem:set_visible(false)
    end

    for _, elem in pairs(misc_elements) do
        elem:set_visible(false)
    end

    for _, elem in pairs(debug_elements) do
        elem:set_visible(false)
    end

    for _, elem in pairs(info_elements) do
        elem:set_visible(false)
    end
end

local function update_tab_visibility()
    local selected_state = state_selector:get()

    if selected_tab == 2 then
        fake_lag_switch:set_visible(true)
        fake_lag_combo:set_visible(true)
        fake_lag_slider:set_visible(true)
    else
        fake_lag_switch:set_visible(false)
        fake_lag_combo:set_visible(false)
        fake_lag_slider:set_visible(false)
    end

    hide_all_elements()

    if selected_tab == 1 then
        for _, elem in pairs(info_elements) do
            elem:set_visible(true)
        end
        state_selector:set_visible(false)
        import_button:set_visible(false)
        export_button:set_visible(false)
        default_button:set_visible(false)
    elseif selected_tab == 2 then
        set_visibility(selected_state)
        state_selector:set_visible(true)
        import_button:set_visible(false)
        export_button:set_visible(false)
        default_button:set_visible(false)
    elseif selected_tab == 3 then
        for _, elem in pairs(visuals_elements) do
            elem:set_visible(true)
        end
        state_selector:set_visible(false)
        import_button:set_visible(false)
        export_button:set_visible(false)
        default_button:set_visible(false)
    elseif selected_tab == 4 then
        for _, elem in pairs(misc_elements) do
            elem:set_visible(true)
        end
        state_selector:set_visible(false)
        import_button:set_visible(true)
        export_button:set_visible(true)
        default_button:set_visible(true)
    elseif selected_tab == 5 then
        for _, elem in pairs(debug_elements) do
            elem:set_visible(true)
        end
        state_selector:set_visible(false)
        import_button:set_visible(false)
        export_button:set_visible(false)
        default_button:set_visible(false)
    end
end

update_tab_visibility()
---@endregion

---@callbacks

client.set_event_callback("pre_render", function()
    if ui.is_menu_open() then
        update_tab_visibility()
        get_session_time()
    end
end)

client.set_event_callback("pre_render", function()
    animfix_setup()
end)
client.set_event_callback("setup_command", function(cmd)
    update_dt_charge(cmd)
    handle_aa(cmd)
    fast_ladder_setup(cmd)
    warmup()
    manual_yaw()
    globals_command_number(cmd)
    freestanding(cmd)
    safehead(cmd)
    anti_stab(cmd)
end)
client.set_event_callback("net_update_end", defensive_check_stage)
client.set_event_callback("predict_command", defensive_check_predict)
client.set_event_callback("paint", function()
    update_bullet_nearby_status()
    render_logs()
    center_indicator()
    render_damage_indicator()
    render_debug_panel()
    render_gradient_text()
    render_manual()
end)
client.set_event_callback("bullet_impact", antibrute)
client.set_event_callback("aim_fire", function(e)
    aim_fire(e)
end)
client.set_event_callback("aim_hit", function(e)
    aim_hit(e)
end)
client.set_event_callback("aim_miss", aim_miss)
client.set_event_callback("shutdown", on_unload)
ui.set(ref.enabled, true)
client.set_event_callback("pre_render", function()
    if ui.is_menu_open() then
        on_load()
    end
end)

---@region Пасхалка
local pre_end_label = pui.label("AA", "Anti-aimbot angles", " ")
local end_label = pui.label("AA", "Anti-aimbot angles", pui.format("\aFFffff11vandal & hakkai®, all rights reserved."))
---@endregion

---@rezik
function Clamp(v, m, M) return math.min(math.max(v, m), M) end
local function NormalizeAngle(a)
    if not a then return 0 end
	while a > 180 do a = a - 360 end
	while a < -180 do a = a + 360 end
	return a
end
local function AngleDifference(dst, src)
	local d = math.fmod(dst - src, 360)
	if dst > src then
		if d >= 180 then d = d - 360 end
	else
		if d <= -180 then d = d + 360 end
	end
	return d
end
local function DegToRad(d) return d * (math.pi / 180) end
local function RadToDeg(r) return r * (180 / math.pi) end

local VTable = {
    Entry = function(i, x, t) return ffi.cast(t, (ffi.cast("void***", i)[0])[x]) end,
    Bind = function(self, m, itf, idx, ts)
        local ci = client.create_interface(m, itf)
        local fn = self.Entry(ci, idx, ffi.typeof(ts))
        return function(...) return fn(ci, ...) end
    end
}

local animstate_t = ffi.typeof[[
    struct {
        char pad0[0x18];
        float anim_update_timer;
        char pad1[0xC];
        float started_moving_time;
        float last_move_time;
        char pad2[0x10];
        float last_lby_time;
        char pad3[0x8];
        float run_amount;
        char pad4[0x10];
        void* entity;
        void* active_weapon;
        void* last_active_weapon;
        float last_client_side_animation_update_time;
        int last_client_side_animation_update_framecount;
        float eye_timer;
        float eye_angles_y;
        float eye_angles_x;
        float goal_feet_yaw;
        float current_feet_yaw;
        float torso_yaw;
        float last_move_yaw;
        float lean_amount;
        char pad5[0x4];
        float feet_cycle;
        float feet_yaw_rate;
        char pad6[0x4];
        float duck_amount;
        float landing_duck_amount;
        char pad7[0x4];
        float current_origin[3];
        float last_origin[3];
        float velocity_x;
        float velocity_y;
        char pad8[0x4];
        float unknown_float1;
        char pad9[0x8];
        float unknown_float2;
        float unknown_float3;
        float unknown;
        float m_velocity;
        float jump_fall_velocity;
        float clamped_velocity;
        float feet_speed_forwards_or_sideways;
        float feet_speed_unknown_forwards_or_sideways;
        float last_time_started_moving;
        float last_time_stopped_moving;
        bool on_ground;
        bool hit_in_ground_animation;
        char pad10[0x4];
        float time_since_in_air;
        float last_origin_z;
        float head_from_ground_distance_standing;
        float stop_to_full_running_fraction;
        char pad11[0x4];
        float magic_fraction;
        char pad12[0x3C];
        float world_force;
        char pad13[0x1CA];
        float min_yaw;
        float max_yaw;
    } **
]]

local NativeGetClientEntity = VTable:Bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")

local function GetAnimState(e)
    if not e then return false end
    local p = type(e) == "cdata" and e or NativeGetClientEntity(e)
    if not p or p == ffi.NULL then return false end
    local vt = ffi.cast("void***", p)
    return ffi.cast(animstate_t, ffi.cast("char*", vt) + 0x9960)[0]
end

local function GetSimulationTime(e)
    local p = NativeGetClientEntity(e)
    if p then
        return entity.get_prop(e, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", p) + 0x26C)[0]
    end
    return 0
end

local function GetMaxDesync(pl)
    local st = GetAnimState(pl)
    if not st then return 0 end
    local sp = Clamp(st.feet_speed_forwards_or_sideways, 0, 1)
    local avg = (st.stop_to_full_running_fraction * -0.3 - 0.2) * sp + 1
    if st.duck_amount > 0 then
        avg = avg + ((st.duck_amount * sp) * (0.5 - avg))
    end
    return Clamp(avg, 0.5, 1)
end

local function IsPlayerAnimating(pl)
    local c, r = GetSimulationTime(pl)
    c, r = toticks(c), toticks(r)
    return toticks(c) ~= nil and toticks(r) ~= nil
end

local function GetChokedPackets(pl)
    if not IsPlayerAnimating(pl) then return 0 end
    local c, _ = GetSimulationTime(pl)
    local diff = globals.curtime() - c
    local ch = Clamp(toticks(math.max(0.0, diff - client.latency())), 0, cvar.sv_maxusrcmdprocessticks:get_string() - 2)
    return ch
end

local function RebuildServerYaw(pl)
    local s = GetAnimState(pl)
    if not s then return 0 end
    local gf = s.goal_feet_yaw
    local ed = AngleDifference(s.eye_angles_y, gf)
    local fs = Clamp(s.feet_speed_forwards_or_sideways, 0, 1)
    local ve = math.sqrt((s.velocity_x or 0)^2 + (s.velocity_y or 0)^2)
    local mv = ve > 0.1
    local og = s.on_ground
    local ln = s.lean_amount or 0
    local ym = (((s.stop_to_full_running_fraction * -0.3) - 0.2) * fs) + 1
    if s.duck_amount > 0 then
        local f = fs
        ym = ym + (s.duck_amount * f) * (0.5 - ym)
    end
    if math.abs(ln) > 0.3 then
        ym = ym + (ln * 0.25)
    end
    if og and mv then
        ym = ym + (0.12 * (ve / 260))
    end
    local yx = Clamp(ym * s.max_yaw, -60, 60)
    local yn = Clamp(ym * s.min_yaw, -60, 60)
    if ed > yx then
        gf = s.eye_angles_y - math.abs(yx)
    elseif ed < yn then
        gf = s.eye_angles_y + math.abs(yn)
    else
        local a = math.abs(ed)
        local mn = math.abs(yn)
        local mx = math.abs(yx)
        if a < mn then
            gf = s.eye_angles_y + (yn * (ed >= 0 and 1 or -1))
        elseif a > mx then
            gf = s.eye_angles_y - (yx * (ed >= 0 and 1 or -1))
        end
    end
    return NormalizeAngle(gf)
end

local Resolver = { 
    Jitter = { Jittering = false, YawCache = {}, JitterCache = 0, Difference = 0 },
    Main = { Mode = 0, Side = 0, Angles = 0 },
    Shots = {}
}

local Cache = {}
local JitterBuffer = 8

local function resetResolverData()
    Resolver.Jitter.Jittering = false
    Resolver.Jitter.YawCache = {}
    Resolver.Jitter.JitterCache = 0
    Resolver.Jitter.Difference = 0
    Resolver.Main.Mode = 0
    Resolver.Main.Side = 0
    Resolver.Main.Angles = 0
    Resolver.Shots = {}
end

local function DetectJitter(pl)
    local j = Resolver.Jitter
    local ey = entity.get_prop(pl, "m_angEyeAngles") or 0
    j.YawCache[j.JitterCache % JitterBuffer] = ey
    j.JitterCache = (j.JitterCache + 1) % (JitterBuffer + 1)
    local mx = 0
    for i = 0, JitterBuffer - 1 do
        local cdx = (i - j.JitterCache) % JitterBuffer
        local df = j.YawCache[cdx] and j.YawCache[j.JitterCache % JitterBuffer]
        if df then
            df = math.abs(j.YawCache[cdx] - df)
            local nd = NormalizeAngle(df)
            if nd > mx then
                mx = nd
            end
        end
    end
    j.Jittering = mx >= (35.0 * GetMaxDesync(pl))
    j.Difference = mx
end

local function DetectDesyncSide(pl)
    local s = GetAnimState(pl)
    if not s then return 0 end
    if Resolver.Jitter.Jittering and GetChokedPackets(pl) < 3 then
        local j = Resolver.Jitter
        local fa = j.YawCache[JitterBuffer - 1] or 0
        local sa = j.YawCache[JitterBuffer - 2] or 0
        Cache.FirstNormalizedAngle = NormalizeAngle(fa)
        Cache.SecondNormalizedAngle = NormalizeAngle(sa)
        local as = (math.sin(DegToRad(Cache.FirstNormalizedAngle)) + math.sin(DegToRad(Cache.SecondNormalizedAngle))) / 2
        local ac = (math.cos(DegToRad(Cache.FirstNormalizedAngle)) + math.cos(DegToRad(Cache.SecondNormalizedAngle))) / 2
        Cache.AVGYaw = NormalizeAngle(RadToDeg(math.atan2(as, ac)))
        Cache.Difference = NormalizeAngle(s.eye_angles_y - Cache.AVGYaw)
        Resolver.Main.Side = Cache.Difference > 0 and 1 or (Cache.Difference < 0 and -1 or 0)
    end
    return Resolver.Main.Side
end

local function ResolverLogic(pl)
    local s = GetAnimState(pl)
    if not s then return end
    DetectJitter(pl)
    DetectDesyncSide(pl)
    local newFeet = RebuildServerYaw(pl)
    local choked = GetChokedPackets(pl)
    local ds = math.abs(NormalizeAngle(s.eye_angles_y - s.torso_yaw))
    local vel = entity.get_prop(pl, "m_vecVelocity[0]") or 0
    local duck = s.duck_amount > 0.1
    local fw = math.abs(AngleDifference(s.eye_angles_y, s.last_move_yaw)) < 5 and vel > 10
    if Resolver.Jitter.Jittering and choked < 3 then
        Resolver.Main.Angles = 0
        Resolver.Main.Mode = 0
    elseif ds >= 40 and vel > 150 then
        Resolver.Main.Angles = NormalizeAngle(newFeet - s.eye_angles_y)
        Resolver.Main.Mode = 1
    elseif ds > 20 and duck then
        Resolver.Main.Angles = NormalizeAngle(newFeet - s.eye_angles_y)
        Resolver.Main.Mode = 1
    elseif fw then
        Resolver.Main.Angles = 0
        Resolver.Main.Mode = 1
    else
        if Resolver.Jitter.Jittering then
            local sc = Resolver.Jitter.Difference > 50 and 50 or Resolver.Jitter.Difference
            Resolver.Main.Angles = sc * GetMaxDesync(pl) * Resolver.Main.Side
            Resolver.Main.Mode = 1
        else
            Resolver.Main.Angles = 0
            Resolver.Main.Mode = 0
        end
    end
end

client.set_event_callback("net_update_end", function()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then 
        Resolver.Main.Mode = 0
        return
    end
    local ps = entity.get_players()
    client.update_player_list()
    for _, idx in ipairs(ps) do
        local sid = entity.get_steam64(idx)
        if entity.is_enemy(idx) and IsPlayerAnimating(idx) and debug_elements.resolver_checkbox:get() and sid ~= 0 then
            ResolverLogic(idx)
            plist.set(idx, "Force body yaw value", Resolver.Main.Mode ~= 0 and Resolver.Main.Angles or 0)
            plist.set(idx, "Force body yaw", Resolver.Main.Mode ~= 0)
        else
            plist.set(idx, "Force body yaw", false)
        end
    end
end)

client.set_event_callback("round_start", function()
    resetResolverData()
end)
---@end