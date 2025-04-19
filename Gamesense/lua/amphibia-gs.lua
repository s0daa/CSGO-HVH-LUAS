-- downloaded from dsc.gg/southwestcfgs

local loader = {
    username = "Odyssey"
}
if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...) return ... end
end
local required = require
local pui = required 'gamesense/pui' or error('failded to load pui')
local base64 = required 'gamesense/base64' or error('failed to load base64')
local clipboard = required "gamesense/clipboard" or error('failed to load clipboard')
local vector = required 'vector' or error('failed to load vector')
local c_entity = required "gamesense/entity" or error('failed to load c_entity')
local c_weapon = required "gamesense/csgo_weapons" or error('failed to load csgo_weapons')
local msgpack = required 'gamesense/msgpack' or error('failed to load msgpack')
local c_entity = required 'gamesense/entity' or error('failed to load c_entity')
local smoothy = (function()
    local function ease(t, b, c, d)
    return c * t / d + b
end

local function get_timer()
    -- use your own timer implementation
    return globals.frametime()
end

local function get_type(value)
    local val_type = type(value)

    if val_type == 'boolean' then
        value = value and 1 or 0
    end

    return val_type
end

local function copy_tables(destination, keysTable, valuesTable)
    valuesTable = valuesTable or keysTable
    local mt = getmetatable(keysTable)

    if mt and getmetatable(destination) == nil then
        setmetatable(destination, mt)
    end

    for k,v in pairs(keysTable) do
        if type(v) == 'table' then
            destination[k] = copy_tables({ }, v, valuesTable[k])
        else
            local value = valuesTable[k]

            if type(value) == 'boolean' then
                value = value and 1 or 0
            end

            destination[k] = value
        end
    end

    return destination
end

local function resolve(easing_fn, previous, new, clock, duration)
    if type(new) == 'boolean' then new = new and 1 or 0 end
    if type(previous) == 'boolean' then previous = previous and 1 or 0 end

    local previous = easing_fn(clock, previous, new - previous, duration)

    if type(new) == 'number' then
        if math.abs(new-previous) <= .001 then
            previous = new
        end

        if previous % 1 < .0001 then
            previous = math.floor(previous)
        elseif previous % 1 > .9999 then
            previous = math.ceil(previous)
        end
    end

    return previous
end

local function perform_easing(ntype, easing_fn, previous, new, clock, duration)
    if ntype == 'table' then
        for k, v in pairs(new) do
            previous[k] = previous[k] or v
            previous[k] = perform_easing(
                type(v), easing_fn,
                previous[k], v,
                clock, duration
            )
        end

        return previous
    end

    return resolve(easing_fn, previous, new, clock, duration)
end

local function update(self, duration, value, easing)
    if type(value) == 'boolean' then
        value = value and 1 or 0
    end

    local clock = get_timer()
    local duration = duration or .15
    local value_type = get_type(value)
    local target_type = get_type(self.value)

    assert(value_type == target_type, 'type mismatch')

    if self.value == value then
        return value
    end

    if clock <= 0 or clock >= duration then
        if target_type == 'table' then
            copy_tables(self.value, value)
        else
            self.value = value
        end
    else
        local easing = easing or self.easing

        self.value = perform_easing(
            target_type, easing,
            self.value, value,
            clock, duration
        )
    end

    return self.value
end

local M = {
    __metatable = false,
    __call = update,

    __index = {
        update = update
    }
}

return function(default, easing_fn)
    if type(default) == 'boolean' then
        default = default and 1 or 0
    end

    return setmetatable({
        value = default or 0,
        easing = easing_fn or ease,
    }, M)
end
end)()
local anti_aim_states = {"Standing", "Running", "Slowwalk", "Ducking", "Air", "Air+Duck", "Safe", 'Fakelag'}
local teams = {"CT", "T"}
local custom_aa = {}
local helpers = {}
local x,y = client.screen_size()
local player_state = 1
local system = {}
local screen_size_x, screen_size_y = client.screen_size()
local pui = require 'gamesense/pui' or error('failded to load pui')
local vector = require "vector"
system.list = {}
system.windows = {}
system.__index = system

local reference do
        reference = { }

        
        reference.fd = {ui.reference("Rage", "Other", "Duck peek assist")}
        reference.dt = {ui.reference("Rage", "Aimbot", "Double Tap")}
        reference.dt_fl = ui.reference("Rage", "Aimbot", "Double tap fake lag limit")
        reference.hs = {ui.reference("AA", "Other", "On shot anti-aim")}
        reference.color = pui.reference('Misc', 'Settings', 'Menu color')
        reference.dmg1 = ui.reference('RAGE', 'Aimbot', 'Minimum damage')
        reference.dmg = {ui.reference("Rage", "Aimbot", "Minimum damage override")}
        reference.fakeduck = ui.reference("RAGE", "Other", "Duck peek assist")
        reference.lua = ui.reference("AA", "Anti-aimbot angles", "Enabled")
        reference.forcebaim = ui.reference("RAGE", "Aimbot", "Force body aim")
        reference.pitch = {ui.reference("AA", "Anti-aimbot angles", "pitch")}
        reference.roll = ui.reference("AA", "Anti-aimbot angles", "roll")
        reference.yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
        reference.lm = pui.reference("AA","Other","Leg movement")
        reference.yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")}
        reference.fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw")
        reference.edgeyaw = ui.reference("AA", "anti-aimbot angles", "Edge yaw")
        reference.yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")}
        reference.bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")}
        reference.freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")}
        reference.slow = {ui.reference("AA", "Other", "Slow motion")}
        reference.consolea = pui.reference('Misc', 'Miscellaneous', 'Draw console output')
        reference.fp = {ui.reference("AA", "Other", "Fake peek")}
        reference.enable = {ui.reference("AA", "Fake lag", "Enabled")}
        reference.amount = ui.reference("AA", "Fake lag", "Amount")
        reference.variance = ui.reference("AA", "Fake lag", "Variance")
        reference.limit = ui.reference("AA", "Fake lag", "Limit")

 
end

local vars = { }
        pui.macros.dot = '\v•  \r'
    
        local group_fakelag = pui.group('AA', 'Fake lag')
        local group = pui.group('AA', 'Anti-aimbot angles')
        local group_other = pui.group("AA", 'Other')

        local selection do
            vars.selection = { }
    
            vars.selection.label = group_fakelag:label('                      amphibia')
    
            vars.selection.tab = group_fakelag:combobox('\f<dot>Selection', { 'Anti Aim', 'Visuals', 'Misc', 'Configs' }, false, false)
            vars.selection.aa_tab = group_fakelag:combobox('\f<dot>Tab', { 'Angles', 'Features' }, false, false):depend({ vars.selection.tab, 'Anti Aim' })
    
            vars.selection.tab_label = group:label(string.format('\f<dot> %s', vars.selection.tab.value))
    
            vars.selection.tab:set_callback(function (self)
                vars.selection.tab_label:set(string.format('\f<dot>%s', self.value))
            end, true)
        end
    
        local antiaim do
            vars.aa = { }
    
            vars.aa.encha = group:multiselect('\f<dot>Features', 'Manual AA', 'Freestand', 'Animations Breaker', 'Edge Yaw Fakeduck', 'Anti-Backstab', 'Fast Ladder Move', 'Static Freestand', 'Static On Warmup', 'Bombsite E Fix'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Features' })
            vars.aa.ground = group:combobox('\f<dot>On Ground', { 'Disabled', 'Static', 'Walking', 'Jitter'}):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Features' }, {vars.aa.encha, 'Animations Breaker'})
            vars.aa.air = group:combobox('\f<dot>In Air', { 'Disabled', 'Static', 'Walking' }):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Features' }, {vars.aa.encha, 'Animations Breaker'})

            vars.aa.manual_left = group:hotkey('\f<dot>Manual Left'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Features' }, {vars.aa.encha, 'Manual AA'})
            vars.aa.manual_right = group:hotkey('\f<dot>Manual Right'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Features' }, {vars.aa.encha, 'Manual AA'})
            vars.aa.freestanding = group:hotkey('\f<dot>Freestanding'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Features' }, {vars.aa.encha, 'Freestand'})
    
        end
    
        local angles do
            vars.angles = { }
    
            vars.angles.type = group:combobox('\f<dot>Mode', { 'Builder', 'Preset' }):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' })
            vars.angles.team = group:combobox('\f<dot>Player Team', 'CT', 'T'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' })
            vars.angles.condition = group:combobox('\f<dot>Player Condition', anti_aim_states):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' })

            vars.angles.label = group:label('\f<dot>You Are Using The \vPreset.'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Preset' })
            vars.angles.label2 = group:label('\f<dot>Everything Is Already \vSet Up.'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Preset' })
            vars.angles.label3 = group:label('\f<dot>Enjoy, \v'..loader.username):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Preset' })
        
        end

        local conditions do

            function export_state(state, team, toteam)
                local config = pui.setup({custom_aa[team][state]})
            
                local data = config:save()
                local encrypted = base64.encode( json.stringify(data) )
            
                import_state(encrypted, state, toteam)
            end
            
            function import_state(encrypted, state,team)
                local data = json.parse(base64.decode(encrypted))
            
                local config = pui.setup({custom_aa[team][state]})
                config:load(data)
            end

            for i, team in next, teams do
                custom_aa[team] = {}
                for k, state in next, anti_aim_states do
                    custom_aa[team][state] = {}

                            custom_aa[team][state].enabled = group:checkbox(string.format('Enable \v%s \v%s \ac8c8c8ffState', state, team))
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] })

                            custom_aa[team][state].pitch = group:combobox(string.format('\f<dot>\v%s ~ \ac8c8c8ffPitch', state), { 'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom' })
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled)
            
                            custom_aa[team][state].pitch_value = group:slider(string.format('\f<dot>Pitch Value %s ', state), -89, 89, 0, true, '°')
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, { custom_aa[team][state].pitch, 'Custom' }, custom_aa[team][state].enabled)

                            custom_aa[team][state].yaw_base = group:combobox(string.format('\f<dot>\v%s ~ \ac8c8c8ffYaw Base', state), { 'Local view', 'At targets' })
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled)

                            custom_aa[team][state].yaw = group:combobox(string.format('\f<dot>\v%s ~ \ac8c8c8ffYaw', state), { 'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair', '180 Left / Right' })
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled)
            
                            custom_aa[team][state].yaw_offset = group:slider(string.format('\f<dot>\v%s ~ \ac8c8c8ffYaw Offset', state), -180, 180, 0, true, '°')
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, { custom_aa[team][state].yaw, '180', 'Spin', 'Static', '180 Z', 'Crosshair' }, custom_aa[team][state].enabled)
            
                            custom_aa[team][state].delayed_swap = group:checkbox(string.format('\f<dot>\v%s ~ \ac8c8c8ffDelayed Swap ', state))
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, { custom_aa[team][state].yaw, '180 Left / Right' }, custom_aa[team][state].enabled)

                            custom_aa[team][state].ticks_delay = group:slider(string.format('\f<dot>\v%s ~ \ac8c8c8ffDelay Ticks ', state), 0, 30, 0, true, 't', 1)
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, custom_aa[team][state].delayed_swap, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, { custom_aa[team][state].yaw, '180 Left / Right' }, custom_aa[team][state].enabled)

                            custom_aa[team][state].yaw_left = group:slider(string.format('\f<dot>\v%s ~ \ac8c8c8ffLeft Offset ', state), -180, 180, 0, true, '°')
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, { custom_aa[team][state].yaw, '180 Left / Right' }, custom_aa[team][state].enabled)
            
                            custom_aa[team][state].yaw_right = group:slider(string.format('\f<dot>\v%s ~ \ac8c8c8ffRight Offset', state), -180, 180, 0, true, '°')
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, { custom_aa[team][state].yaw, '180 Left / Right' }, custom_aa[team][state].enabled)

                            custom_aa[team][state].body_yaw = group:combobox(string.format('\f<dot>\v%s ~ \ac8c8c8ffBody Yaw', state), { 'Off', 'Static', 'Jitter', 'Opposite'})
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled)
            
                            custom_aa[team][state].body_yaw_offset = group:slider(string.format('\f<dot>\v%s ~ \ac8c8c8ffBody Yaw Offset', state), -180, 180, 0, true, '°')
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, { custom_aa[team][state].body_yaw, 'Jitter', 'Static', 'Opposite'}, custom_aa[team][state].enabled)

                            custom_aa[team][state].yaw_modifier = group:combobox(string.format('\f<dot>\v%s ~ \ac8c8c8ffYaw Jitter', state), { 'Off', 'Offset', 'Center', 'Random', 'Skitter' })
                            :depend({ vars.selection.tab, 'Anti Aim' }, {vars.angles.team, teams[i]},{ vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, { custom_aa[team][state].yaw, 'Off', true }, custom_aa[team][state].enabled)
            
                            custom_aa[team][state].yaw_modifier_offset = group:slider(string.format('\f<dot>\v%s ~ \ac8c8c8ffJitter Offset', state), -180, 180, 0, true, '°')
                            :depend({ vars.selection.tab, 'Anti Aim' }, {vars.angles.team, teams[i]},{ vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, { custom_aa[team][state].yaw, 'Off', true }, { custom_aa[team][state].yaw_modifier, 'Off', true }, custom_aa[team][state].enabled)
            
                            custom_aa[team][state].defensive = group:checkbox(string.format('\f<dot>\v%s ~ \ac8c8c8ffForce Defensive', state))
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled)

                            custom_aa[team][state].defensive_mode = group:multiselect(string.format('\f<dot>\v%s ~ \ac8c8c8ffDefensive Mode', state), {'Double Tap', 'Hide Shots'})
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled,custom_aa[team][state].defensive)

                            custom_aa[team][state].defensive_pitch = group:combobox(string.format('\f<dot>\v%s ~ \ac8c8c8ffDefensive Pitch', state), {'Off', 'Default', 'Up', 'Up-Switch', 'Random', 'Custom'})
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled,custom_aa[team][state].defensive)

                            custom_aa[team][state].pitch_amount = group:slider(string.format('\f<dot>\v%s ~ \ac8c8c8ffOffset', state), -89, 89, 0, true, '°', 1)
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled , {custom_aa[team][state].defensive_pitch, 'Custom', 'Random'},custom_aa[team][state].defensive)

                            custom_aa[team][state].pitch_amount_2 = group:slider(string.format('\f<dot>\v%s ~ \ac8c8c8ffOffset 2', state), -89, 89, 0, true, '°', 1)
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled, {custom_aa[team][state].defensive_pitch, 'Random'},custom_aa[team][state].defensive)

                            custom_aa[team][state].defensive_yaw = group:combobox(string.format('\f<dot>\v%s ~ \ac8c8c8ffDefensive Yaw', state), {'Off', '180', 'Random', 'Spin'})
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled,custom_aa[team][state].defensive)

                            custom_aa[team][state].yaw_amount = group:slider(string.format('\f<dot>\v%s ~ \ac8c8c8ffDefensive Yaw Offset', state), -180, 180, 0, true, '°', 1)
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled, {custom_aa[team][state].defensive_yaw, 'Spin'},custom_aa[team][state].defensive)

                            local test_team = team == "CT" and "T" or "CT"
                            custom_aa[team][state].export_opposite_team = group:button("Export To [\v"..test_team.." - "..state.."\ac8c8c8ff]", function() export_state(state, team, test_team) client.color_log(195,198,255, 'amphibia · \0') client.color_log(200,200,200, 'Exported to '..test_team..' - '..state..'.')  end)
                            :depend({ vars.selection.tab, 'Anti Aim' },{vars.angles.team, teams[i]}, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, anti_aim_states[k] }, custom_aa[team][state].enabled)


            end
      end
 end
    
       
    
        local visuals do
            vars.visuals = { }
    
            vars.visuals.indicators = group:checkbox('Screen Indicators'):depend({ vars.selection.tab, 'Visuals' })
            vars.visuals.widgets = group:multiselect('\f<dot>Select', 'Damage Indicator', 'Anti-Aim Arrows', 'Hitmarker'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.indicators)
            
            vars.visuals.damage_style = group:combobox('\f<dot>Damage Style', '#1', '#2'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.indicators,{vars.visuals.widgets, "Damage Indicator"})
          
            vars.visuals.label_arrows = group:label('\f<dot>Arrows Color'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.indicators,{vars.visuals.widgets, "Anti-Aim Arrows"})
            vars.visuals.manual_arrows_color = group:color_picker('anti-aim arrows color', 195,198,255,255):depend({ vars.selection.tab, 'Visuals' },vars.visuals.indicators,{vars.visuals.widgets, "Anti-Aim Arrows"})
          
            vars.visuals.hitmarker = group:label('\f<dot>Hitmarker Color'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.indicators,{vars.visuals.widgets, "Hitmarker"})
            vars.visuals.hitmarker_color = group:color_picker('Hitmarker color', 168, 168, 168,255):depend({ vars.selection.tab, 'Visuals' },vars.visuals.indicators,{vars.visuals.widgets, "Hitmarker"})

            vars.visuals.watermark = group:checkbox('Watermark'):depend({ vars.selection.tab, 'Visuals' })
            vars.visuals.watermark_mode = group:combobox('\f<dot>Mode ', '#1', '#2'):depend({ vars.selection.tab, 'Visuals' },vars.visuals.watermark)
            vars.visuals.watermark_position = group:combobox('\f<dot>Position', 'Left', 'Right'):depend({ vars.selection.tab, 'Visuals' },vars.visuals.watermark, {vars.visuals.watermark_mode, '#1'})
            vars.visuals.label_watermark = group:label('\f<dot>Watermark Color First'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.watermark, {vars.visuals.watermark_mode, '#1'})
            vars.visuals.watermark_color = group:color_picker('Watermark Color', 155, 155, 200,255):depend({ vars.selection.tab, 'Visuals' },vars.visuals.watermark, {vars.visuals.watermark_mode, '#1'})
            vars.visuals.label_watermark2 = group:label('\f<dot>Watermark Color Second'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.watermark, {vars.visuals.watermark_mode, '#1'})
            vars.visuals.watermark_color2 = group:color_picker('Watermark Color 2', 0,0,0,255):depend({ vars.selection.tab, 'Visuals' },vars.visuals.watermark, {vars.visuals.watermark_mode, '#1'})
            vars.visuals.watermark_items = group:multiselect('\f<dot>Items', 'Username', 'Latency', 'Framerate', 'Time'):depend({ vars.selection.tab, 'Visuals' }, {vars.visuals.watermark_mode, '#2'})
            vars.visuals.watermark_color_mode_2 = group:color_picker('Watermark Color Mode 2', 155, 155, 200,255):depend({ vars.selection.tab, 'Visuals' },vars.visuals.watermark, {vars.visuals.watermark_mode, '#2'})

            
            vars.visuals.slowed = group:checkbox('Slowed Down'):depend({ vars.selection.tab, 'Visuals' })
            vars.visuals.label_slowed = group:label('\f<dot>Velocity Color'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.slowed)
            vars.visuals.color_slowed = group:color_picker('velocity color', 195,198,255,255):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.slowed)
            vars.visuals.velocity_x = group:slider('Velocity X', 0, x, x/2-82) 
            vars.visuals.velocity_y = group:slider('Velocity Y', 0, y, y/2 - 300)
            vars.visuals.velocity_x:set_visible(false)
            vars.visuals.velocity_y:set_visible(false)
            
            vars.visuals.logs = group:checkbox('Log Aimbot Shots'):depend({ vars.selection.tab, 'Visuals' })
            vars.visuals.full_color = group:checkbox('Full Color Logs'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.logs)
            vars.visuals.label4 = group:label('\f<dot>Hit Color'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.logs)
            vars.visuals.hit_color = group:color_picker('hit color', 150, 200, 59,255):depend({ vars.selection.tab, 'Visuals' },vars.visuals.logs)
            vars.visuals.label5 = group:label('\f<dot>Miss Color'):depend({ vars.selection.tab, 'Visuals' },vars.visuals.logs)
            vars.visuals.miss_color = group:color_picker('miss color', 158, 69, 69, 255):depend({ vars.selection.tab, 'Visuals' },vars.visuals.logs)
            
            reference.consolea:depend(true, { vars.visuals.logs, false })

        end
    
        local misc do
            vars.misc = { }
        
                vars.misc.enabled = group:checkbox('Drop Grenades'):depend({ vars.selection.tab, 'Misc' })
                vars.misc.hk = group:hotkey('Hotkey', true):depend({ vars.selection.tab, 'Misc'}, vars.misc.enabled)
                vars.misc.selection = group:multiselect('\f<dot>Items', 'Smoke', 'He Grenade', 'Molotov/Incendiary'):depend({ vars.selection.tab, 'Misc'}, vars.misc.enabled)
                
                vars.misc.warmup_helper = group:checkbox('Warmup Helper'):depend({ vars.selection.tab, 'Misc'})
                vars.misc.warmup_helper:set_callback(function (self)
                    if self:get() then
                        client.exec("sv_cheats 1; sv_regeneration_force_on 1; mp_limitteams 0; mp_autoteambalance 0; mp_roundtime 60; mp_roundtime_defuse 60; mp_maxmoney 60000; mp_startmoney 60000; mp_freezetime 0; mp_buytime 9999; mp_buy_anywhere 1; sv_infinite_ammo 1; ammo_grenade_limit_total 5; bot_kick; bot_stop 1; mp_warmup_end; mp_restartgame 1; mp_respawn_on_death_ct 1; mp_respawn_on_death_t 1; sv_airaccelerate 100;")   
                    end
                end, true)
                
                vars.misc.aspectratio = group:checkbox('Aspect Ratio'):depend({ vars.selection.tab, 'Misc'})
                vars.misc.asp_offset = group:slider('\f<dot>Aspect Ratio Value', 0,200,0):depend({ vars.selection.tab, 'Misc'}, vars.misc.aspectratio)
                vars.misc.aspectratio:set_callback(function (self)
                    if not self:get() then cvar.r_aspectratio:set_raw_float(0) end
                end, true)
                
                vars.misc.thirdperson = group:checkbox('Thirdperson'):depend({ vars.selection.tab, 'Misc'})
                vars.misc.distance_slider = group:slider("\f<dot>Distance", 30, 200, 150):depend({ vars.selection.tab, 'Misc'}, vars.misc.thirdperson)
                
                vars.misc.viewmodel = group:checkbox('Viewmodel'):depend({ vars.selection.tab, 'Misc'})
                vars.misc.viewmodel_fov = group:slider('\f<dot>FOV', 0,100, 68):depend({ vars.selection.tab, 'Misc'}, vars.misc.viewmodel)
                vars.misc.viewmodel_x = group:slider('\f<dot>X', -100,100,25, true,'', 0.1):depend({ vars.selection.tab, 'Misc'}, vars.misc.viewmodel)
                vars.misc.viewmodel_y = group:slider('\f<dot>Y', -100,100,0, true,'', 0.1):depend({ vars.selection.tab, 'Misc'}, vars.misc.viewmodel)
                vars.misc.viewmodel_z = group:slider('\f<dot>Z', -100,100,-15, true,'', 0.1):depend({ vars.selection.tab, 'Misc'}, vars.misc.viewmodel)
                vars.misc.viewmodel:set_callback(function (self)
                    if not self:get() then cvar.viewmodel_fov:set_raw_float(68) cvar.viewmodel_offset_x:set_raw_float(2.5) cvar.viewmodel_offset_y:set_raw_float(0) cvar.viewmodel_offset_z:set_raw_float(-1.5) end
                end, true)

        end
    
        local configs do
            vars.configs = { }

            vars.configs.cfg_label = group_other:label('\f<dot>New Config'):depend({ vars.selection.tab, 'Configs'})
            vars.configs.list = group:listbox('\nConfig List', { 'No Configs!' }, '', false):depend({ vars.selection.tab, 'Configs' })
            vars.configs.name = group_other:textbox('\nConfig Name', '', false):depend({ vars.selection.tab, 'Configs' })
            vars.configs.load = group:button('Load', nil, true):depend({ vars.selection.tab, 'Configs' })
            vars.configs.create = group_other:button('Create', nil, true):depend({ vars.selection.tab, 'Configs' })
            vars.configs.save = group:button('Save', nil, true):depend({ vars.selection.tab, 'Configs' })
            vars.configs.export = group:button('Export', nil, true):depend({ vars.selection.tab, 'Configs' })
            vars.configs.import = group_other:button('Import', nil, true):depend({ vars.selection.tab, 'Configs' })
            vars.configs.delete = group:button('Delete', nil, true):depend({ vars.selection.tab, 'Configs' })


        end

        local statistics do
            vars.statistics = { }

            vars.statistics.label144 = group_other:label('\f<dot>Information'):depend({ vars.selection.tab, 'Anti Aim', 'Visuals', 'Misc'})
            vars.statistics.user = group_other:label('\f<dot>User: \v'..loader.username):depend({ vars.selection.tab, 'Anti Aim', 'Visuals', 'Misc'})
            vars.statistics.loaded = group_other:label('\f<dot>Times Loaded: \v'):depend({ vars.selection.tab, 'Anti Aim', 'Visuals', 'Misc'})
            vars.statistics.time_in_game = group_other:label('\f<dot>Session: '):depend({ vars.selection.tab, 'Anti Aim', 'Visuals', 'Misc'})
            
        end



helpers['functions'] = {
    alpha_vel = smoothy(0), is_bd_alpha = smoothy(0), velocity_smoth = smoothy(0), time = globals.realtime(), side = 0,  prev_side = 0, canbepressed = true, damage_anim = 0, defensive_ticks = 0, is_backstab = false, grenades_list = { }, prev_wpn, hitmarker_data = {},framerate = 0, last_framerate = 0, ticks = 0, delayed_switch = false,
    is_bounded = function(self, vec1_x, vec1_y, vec2_x, vec2_y) local mouse_pos_x, mouse_pos_y = ui.mouse_position() return mouse_pos_x >= vec1_x and mouse_pos_x <= vec2_x and mouse_pos_y >= vec1_y and mouse_pos_y <= vec2_y end,
    lerp = function (self, start, end_, speed, delta) if entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 0 then local time = globals.frametime() * (3) return ((end_ ) * time + start) else local time = globals.frametime() * (5) return ((end_ ) * time + start) end end,
    get_damage = function(self) if ui.get(reference.dmg[1]) and ui.get(reference.dmg[2]) then return ui.get(reference.dmg[3]) end return ui.get(reference.dmg1) end,
    get_player_weapons = function(self, ent) local weapons = { }; for i = 0, 63 do local weapon = entity.get_prop(ent, "m_hMyWeapons", i); if weapon == nil then goto continue; end weapons[#weapons + 1] = weapon; ::continue:: end return weapons; end,
    is_class_grenades = function(self, item_class) if item_class == "weapon_smokegrenade" then return vars.misc.selection:get("Smoke"); end if item_class == "weapon_hegrenade" then return vars.misc.selection:get("He Grenade"); end if item_class == "weapon_incgrenade" or item_class == "weapon_molotov" then return vars.misc.selection:get("Molotov/Incendiary"); end return false; end,
    is_needed_weapon = function(self, weapon) local info = c_weapon(weapon); if info.weapon_type_int ~= 9 then return false; end if not self:is_class_grenades(info.item_class) then return false; end return true; end,
    update_player_weapons = function(self, ent) local weapons = self:get_player_weapons(ent); for i = 1, #weapons do local weapon = weapons[i]; if not self:is_needed_weapon(weapon) then goto continue; end self.grenades_list[#self.grenades_list + 1] = weapon; ::continue:: end end,
    lerp2 = function(self, x, v, t) if type(x) == 'table' then return self:lerp2(x[1], v[1], t), self:lerp2(x[2], v[2], t), self:lerp2(x[3], v[3], t), self:lerp2(x[4], v[4], t) end local delta = v - x if type(delta) == 'number' then if math.abs(delta) < 0.005 then return v end end return delta * t + x end,
    is_dt_charged = function(self) if not entity.get_local_player() then return end local weapon = entity.get_player_weapon(entity.get_local_player()) if entity.get_local_player() == nil or weapon == nil then return false end if globals.curtime() - (16 * globals.tickinterval()) < entity.get_prop(entity.get_local_player(), 'm_flNextAttack') then return false end if globals.curtime() - (0 * globals.tickinterval()) < entity.get_prop(weapon, 'm_flNextPrimaryAttack') then return false end return true end,
    is_defensive = function(self, index) self.defensive_ticks = math.max(entity.get_prop(index, 'm_nTickBase'), self.defensive_ticks or 0) return math.abs(entity.get_prop(index, 'm_nTickBase') - self.defensive_ticks) > 2 and math.abs(entity.get_prop(index, 'm_nTickBase') - self.defensive_ticks) < 14 end,
    contains = function(self, inputString) if type(inputString) == "string" then if string.find(inputString, "%s") ~= nil and string.find(inputString, "%S") ~= nil then local hasSpace = string.find(inputString, "%s") ~= nil local hasCharacters = string.find(inputString, "%S") ~= nil return hasSpace and hasCharacters elseif string.find(inputString, "%s") == nil and string.find(inputString, "%S") ~= nil then local hasSpace = string.find(inputString, "%s") == nil local hasCharacters = string.find(inputString, "%S") ~= nil return hasSpace and hasCharacters else return false end else return false  end end,
    animations = (function ()local a={data={}}function a:clamp(b,c,d)return math.min(d,math.max(c,b))end;function a:animate(e,f,g)if not self.data[e]then self.data[e]=0 end;g=g or 4;local b=globals.frametime()*g*(f and-1 or 1)self.data[e]=self:clamp(self.data[e]+b,0,1)return self.data[e]end;return a end)(),
    rgba_to_hex = function(self,b,c,d,e) return string.format('%02x%02x%02x%02x',b,c,d,e) end,
    fade_handle = function(self, time, string, r, g, b, a) local color1, color2, color3, color4 = vars.visuals.watermark_color2:get() local t_out, t_out_iter = { }, 1 local l = string:len( ) - 1 local r_add = (color1 - r) local g_add = (color2 - g) local b_add = (color3 - b) for i = 1, #string do local iter = (i - 1)/(#string - 1) + time t_out[t_out_iter] = "\a" .. self:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a  ) t_out[t_out_iter + 1] = string:sub( i, i ) t_out_iter = t_out_iter + 2 end return t_out end,
    fade_handle2 = function(self, time, string, r, g, b, a) local color1, color2, color3, color4 = 32, 32, 32, 255 local t_out, t_out_iter = { }, 1 local l = string:len( ) - 1 local r_add = (color1 - r) local g_add = (color2 - g) local b_add = (color3 - b) for i = 1, #string do local iter = (i - 1)/(#string - 1) + time t_out[t_out_iter] = "\a" .. self:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a  ) t_out[t_out_iter + 1] = string:sub( i, i ) t_out_iter = t_out_iter + 2 end return t_out end,
    manualaa = function(self) if not vars.aa.encha:get("Manual AA") then self.side = 0 return 0 end self.canbepressed = self.time+0.2 < globals.realtime() if  vars.aa.manual_left:get() and self.canbepressed then self.side = 1 if self.prev_side == self.side then self.side = 0 end self.time = globals.realtime() end if vars.aa.manual_right:get() and self.canbepressed then self.side = 2 if self.prev_side ==self.side then self.side = 0 end self.time = globals.realtime() end self.prev_side = self.side if self.side == 1 then return 1 end  if self.side == 2 then return 2 end  if self.side == 0 then return 0 end end,
    update_session = function(self) local seconds_ses = math.floor(globals.realtime()) local hours_ses = math.floor(globals.realtime()/3600) local minutes_ses = math.floor(globals.realtime()/60) if seconds_ses == 1 and hours_ses < 1 and minutes_ses < 1 then text = seconds_ses.." Second" elseif seconds_ses >= 2 and hours_ses < 1 and minutes_ses < 1 then text = seconds_ses.." Seconds" elseif minutes_ses >= 2 and hours_ses < 1 then text = minutes_ses.." Minutes" elseif minutes_ses == 1 and hours_ses < 1 then text = minutes_ses.." Minute" elseif hours_ses < 2 then text = hours_ses.." Hour" elseif hours_ses >= 2 then text = hours_ses.." Hours" end vars.statistics.time_in_game:set('\f<dot>Session: \v'..text) end,
}
system.register = function(position, size, global_name, ins_function) local data = { size = size, position = vector(position[1]:get(), position[2]:get()), is_dragging = false, drag_position = vector(), global_name = global_name, ins_function = ins_function, ui_callbacks = {x = position[1], y = position[2]} } table.insert(system.windows, data) return setmetatable(data, system) end
function system:limit_positions() if self.position.x <= 0 then self.position.x = 0 end if self.position.x + self.size.x >= screen_size_x - 1 then self.position.x = screen_size_x - self.size.x - 1 end if self.position.y <= 0 then self.position.y = 0 end if self.position.y + self.size.y >= screen_size_y - 1 then self.position.y = screen_size_y - self.size.y - 1 end end
function system:is_in_area(mouse_position) return mouse_position.x >= self.position.x and mouse_position.x <= self.position.x + self.size.x and mouse_position.y >= self.position.y and mouse_position.y <= self.position.y + self.size.y end
function system:update(...) if ui.is_menu_open() then local mouse_position = vector(ui.mouse_position()) local is_in_area = self:is_in_area(mouse_position) local list = system.list local is_key_pressed = client.key_state(1) if (is_in_area or self.is_dragging) and is_key_pressed and (list.target == "" or list.target == self.global_name) then list.target = self.global_name if not self.is_dragging then self.is_dragging = true self.drag_position = mouse_position - self.position else self.position = mouse_position - self.drag_position self:limit_positions() self.ui_callbacks.x:set(math.floor(self.position.x)) self.ui_callbacks.y:set(math.floor(self.position.y)) end elseif not is_key_pressed then list.target = "" self.is_dragging = false self.drag_position = vector() end end self.ins_function(self, ...) end

hide_menu = function(state)
    
    ui.set_visible(reference.lua, state)
    ui.set_visible(reference.pitch[1], state)
    ui.set_visible(reference.pitch[2],state)
    ui.set_visible(reference.roll,state)
    ui.set_visible(reference.yawbase,state)
    ui.set_visible(reference.yaw[1],state)
    ui.set_visible(reference.yaw[2],state)
    ui.set_visible(reference.yawjitter[1],state)
    ui.set_visible(reference.yawjitter[2],state)
    ui.set_visible(reference.bodyyaw[1],state)
    ui.set_visible(reference.bodyyaw[2],state)
    ui.set_visible(reference.freestand[1],state)
    ui.set_visible(reference.freestand[2],state)
    ui.set_visible(reference.fsbodyyaw,state)
    ui.set_visible(reference.edgeyaw,state)
    ui.set_visible(reference.enable[1],state)
    ui.set_visible(reference.enable[2],state)
    ui.set_visible(reference.amount,state)
    ui.set_visible(reference.variance,state)
    ui.set_visible(reference.limit,state)
    ui.set_visible(reference.slow[1],state)
    ui.set_visible(reference.slow[2],state)
    ui.set_visible(reference.hs[1],state)
    ui.set_visible(reference.hs[2],state)
    ui.set_visible(reference.fp[1],state)
    ui.set_visible(reference.fp[2],state)
    ui.set_visible(reference.amount,state)
    ui.set_visible(reference.limit,state)
    reference.lm:set_visible(state)

end


LPH_NO_VIRTUALIZE(function()

    local db do
        db = { }
    
        setmetatable(db, {
            __index = function (self, key)
                return database.read(key)
            end,
    
            __newindex = function (self, key, value)
                return database.write(key, value)
            end
        })
    end 

    local data = db.configs_data_amphibia_lua or { }
    local loaded_times = db.loaded_times_amphibia_lua or 1;
    loaded_times = loaded_times + 1;


    client.set_event_callback('paint_ui', function()

        vars.statistics.loaded:set('\f<dot>Times Loaded: \v'..db.loaded_times_amphibia_lua)

    end)
    db.loaded_times_amphibia_lua = loaded_times;


    if type(data) ~= 'table' then
        data = { }
    end

    function export()
        local config = pui.setup({custom_aa}):save()
        if config == nil then
            return
        end

        local data = {
            author = loader.username,
            data = config,
            name = vars.configs.name.value,
            mode = vars.angles.type.value

        }

        local success, packed = pcall(msgpack.pack, data)
        if not success then
            return
        end

        local success, encode = pcall(base64.encode, packed)
        if not success then
            return
        end

        return string.format('amphibia:%s_amphibia', encode)
    end

    function import(str)
        local config = str or clipboard.get()
        if config == nil then
            client.color_log(255, 175, 175, 'amphibia · \0')
            client.color_log(200,200,200, 'Config is empty.')
            return
        end

        if string.sub(config, 1, #'amphibia:') ~= 'amphibia:' then
            client.color_log(255, 175, 175, 'amphibia · \0')
            client.color_log(200,200,200, 'Config data is nil.')
            return
        end

        config = config:gsub('amphibia:', ''):gsub('_amphibia', '')

        local success, decoded = pcall(base64.decode, config)
        if not success then
            client.color_log(255, 175, 175, 'amphibia · \0')
            client.color_log(200,200,200, 'Failed to decode config.')
            return
        end

        local success, data = pcall(msgpack.unpack, decoded)
        if not success then
            client.color_log(255, 175, 175, 'amphibia · \0')
            client.color_log(200,200,200, 'Failed to parse data.')
            return
        end

        pui.setup({custom_aa}):load(data.data)
    end

    local configs_mt = {
        __index = {
            load = function(self)
                import(self.data)
            end,

            export = function(self)
                if not self.data:find('_amphibia') then
                    self.data = string.format('%s_amphibia', self.data)
                end

                clipboard.set(self.data)
            end,

            save = function(self, data)
                if data == nil then
                    data = export()
                end

                self.data = data
                self.mode = vars.angles.type.value

            end,

            to_db = function(self)
                return {
                    name = self.name,
                    data = self.data,
                    author = loader.username,
                    mode = self.mode

                }
            end
        }
    }

    local database_mt = setmetatable({ }, {
        __index = function(self, key)
            local storage = data.configs

            if storage == nil then
                return nil
            end

            local success, parsed = pcall(json.parse, storage)
            if not success then
                return nil
            end

            return parsed[ key ]
        end,

        __newindex = function(self, key, v)
            local storage = data.configs

            if storage == nil then
                storage = '{}'
            end

            local success, parsed = pcall(json.parse, storage)
            if not success then
                parsed = { }
            end

            parsed[ key ] = v

            data.configs = json.stringify(parsed)
        end
    })

    local live_list = { }

    function strip(str)
    while str:sub(1, 1) == ' ' do
        str = str:sub(2)
    end

    while str:sub(#str, #str) == ' ' do
        str = str:sub(1, #str - 1)
    end

    if #str == 0 or str == '' then
        str = string.format("%s's %s", loader.username, 'Config')
    end

    return str
end

    function update_list()
        local list_names = { }

        local val = vars.configs.list:get() + 1

        for i = 1, #live_list do
            local obj = live_list[ i ]

            list_names[ #list_names + 1 ] = string.format('%s%s', val == i and '\a' .. pui.accent .. '• ' or '', obj.name)
        end

        if #list_names == 0 then
            list_names[ #list_names + 1 ] = 'Config list is empty!'
        end

        vars.configs.list:update(list_names)
    end

    function find(name)
        name = strip(name)

        for i = 1, #live_list do
            local obj = live_list[ i ]

            if obj.name == name then
                return obj, i
            end
        end
    end

    function create(name, data, author, mode)
        
        name = strip(name)

        local new_preset = {
            name = name,
            data = data or export(),
            author = author or loader.username,
            mode = mode or vars.angles.type.value

        }

        live_list[ #live_list + 1 ] = setmetatable(new_preset, configs_mt)

        update_list()
        flush()
    end

    function on_list_name()
        if #live_list == 0 then
            return vars.configs.name:set('')
        end

        local selected_preset = live_list[ vars.configs.list:get() + 1 ]

        if selected_preset == nil then
            selected_preset = live_list[ #live_list ]
        end

        vars.configs.name:set(selected_preset.name)
    end

    function destroy(preset)
        for i = 1, #live_list do
            local obj = live_list[ i ]

            if obj.name == preset.name then
                table.remove(live_list, i)
                break
            end
        end

        update_list()
        flush()
        on_list_name()
    end

    function init()
        local db_info = database_mt[ 'amphibia' ]

        if db_info == nil then
            db_info = { }
        end

        for i = 1, #db_info do
            local obj = db_info[ i ]

            live_list[ i ] = setmetatable(obj, configs_mt)
        end

        update_list()
        on_list_name()
    end

    function flush()
        local db_info = { }

        for i = 1, #live_list do
            local obj = live_list[ i ]

            db_info[ #db_info + 1 ] = obj:to_db()
        end

        database_mt[ 'amphibia' ] = db_info
    end

    local sentences = {
        ['load'] = 'loaded',
        ['export'] = 'exported'
    }

    for _, type in next, { 'load', 'export' } do
        vars.configs[ type ]:set_callback(function()
            local selected_name = vars.configs.name:get()
            local selected_preset, id = find(selected_name)

            if selected_preset == nil then
                client.color_log(255, 175, 175, 'amphibia · \0')
                client.color_log(200,200,200, 'Config is nil.')
                return
            end

            vars.angles.type:set(selected_preset.mode)
            client.color_log(195,198,255, 'amphibia · \0')
            client.color_log(200,200,200, 'Successfully '..sentences[ type ].." "..selected_preset.name..'.')
            selected_preset[type](selected_preset)

            on_list_name()
            update_buttons()
        end)
    end

    vars.configs.save:set_callback(function()
        local selected_name = vars.configs.name:get()
        local selected_preset, id = find(selected_name)

            client.color_log(195,198,255, 'amphibia · \0')
            client.color_log(200,200,200, 'Preset saved: '..strip(selected_name)..'.')
            selected_preset:save()

        on_list_name()
        update_buttons()
    end)

    vars.configs.create:set_callback(function()
        local selected_name = vars.configs.name:get()
        local selected_preset, id = find(selected_name)

        if selected_preset == nil then
            if helpers['functions']:contains(selected_name) then
            create(selected_name)
            vars.configs.list:set(#live_list)
            client.color_log(195,198,255, 'amphibia · \0')
            client.color_log(200,200,200, 'Preset created: '..selected_name..'.')
            else
            client.color_log(255, 175, 175, 'amphibia · \0')
            client.color_log(200,200,200, 'Config is nil.')
            end
        else
            client.color_log(255, 175, 175, 'amphibia · \0')
            client.color_log(200,200,200, 'Config is already added.')
        end

        on_list_name()
        update_buttons()
    end)

    vars.configs.import:set_callback(function ()
        local clipboard_text = clipboard.get()
        local s = clipboard_text
        if s == nil then
            client.color_log(255, 175, 175, 'amphibia · \0')
            client.color_log(200,200,200, 'Your clipboard is empty.')
            return 
        end

        do
            if s:sub(1, #'amphibia:') ~= 'amphibia:' then
                client.color_log(255, 175, 175, 'amphibia · \0')
                client.color_log(200,200,200, 'Config is corrupted.')
                return 
            end

            s = s:sub(#'amphibia:' + 1)

            if s:find('_amphibia') then
                s = s:gsub('_amphibia', '')
            end
        end

        local success, decoded = pcall(base64.decode, s)
        if not success then
            client.color_log(255, 175, 175, 'amphibia · \0')
            client.color_log(200,200,200, 'Failed to decode config.')
            return
        end

        local success, unpacked = pcall(msgpack.unpack, decoded)
        if not success then
            client.color_log(255, 175, 175, 'amphibia · \0')
            client.color_log(200,200,200, 'Failed to unpack config.')
            return 
        end

        local selected_preset, id = find(unpacked.name)

        if selected_preset == nil then
            client.color_log(195,198,255, 'amphibia · \0')
            client.color_log(200,200,200, 'Preset added by '..unpacked.author..'.')
            create(unpacked.name, clipboard_text, unpacked.author, unpacked.mode)
            vars.configs.list:set(#live_list)
        else
            client.color_log(195,198,255, 'amphibia · \0')
            client.color_log(200,200,200, 'Preset rewrited: '..unpacked.author..'.')

            selected_preset:save(clipboard_text)

        end

        import(clipboard_text)
        on_list_name()
        update_buttons()
    end)

    vars.configs.delete:set_callback(function()
        local selected_name = vars.configs.name:get()
        local selected_preset, id = find(selected_name)

        if selected_preset == nil then
            return
        end

        client.color_log(195,198,255, 'amphibia · \0')
        client.color_log(200,200,200, 'Preset deleted: '..selected_preset.name..'.')

        destroy(selected_preset)
        update_buttons()
    end)

    function update_buttons()
        local selected_name = vars.configs.name:get()
        local selected_preset, id = find(selected_name)

        local state = selected_preset ~= nil
        vars.configs.save:set_enabled(state)
        vars.configs.load:set_enabled(state)
        vars.configs.export:set_enabled(state)
        vars.configs.delete:set_enabled(state)
    end

    vars.configs.list:set_callback(function (self)
        local selected_name = vars.configs.name:get()
        local selected_preset, id = find(selected_name)

        on_list_name()
        update_list()
        update_buttons()
    end, true)

    init()
    client.delay_call(.1, function ()
        on_list_name()
        update_buttons()
    end)

    client.set_event_callback('shutdown', function()

        flush()
        data.stored_config = export()
        db.configs_data_amphibia_lua = data
        db.loaded_times_amphibia_lua = loaded_times;
    
    end)

end)()

LPH_NO_VIRTUALIZE(function ()
condition_get = function(c)    
    local vx, vy, vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
            
    local lp_vel = math.sqrt(vx*vx + vy*vy + vz*vz)
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1 and c.in_jump == 0
    local is_crouching = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 4) == 4
    local p_slow = ui.get(reference.slow[1]) and ui.get(reference.slow[2])
    local is_knife = entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == 'CKnife' and on_ground == false and is_crouching == true or entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == 'CKnife' and on_ground == true and is_crouching == true
    local fakelag  = not(ui.get(reference.dt[2]) or ui.get(reference.hs[2]))
    
    if fakelag then
        player_state = 8
        return "Fakelag"
    elseif is_knife then
        player_state = 7
        return "Safe"
    elseif (on_ground and is_crouching) or ui.get(reference.fd[1]) then
        player_state = 4
        return "Ducking"
    elseif ((c.in_duck == 1) and (not on_ground)) then
        player_state = 6
        return "Air+Duck"
    elseif (not on_ground) and (c.in_duck == 0)then
        player_state = 5
        return "Air"
    elseif p_slow then
        player_state = 3
        return "Slowwalk"
    elseif (lp_vel > 5) then
        player_state = 2
        return "Running"
    else
        player_state = 1
        return "Standing"
    end 
end

handle_static_freestand = function(c)

    if vars.aa.encha:get('Freestand') and vars.aa.freestanding:get()  then
        if vars.aa.encha:get('Static Freestand') then
        ui.set(reference.freestand[1], true)
        ui.set(reference.freestand[2], "Always on")
        ui.set(reference.bodyyaw[1], 'off')
        ui.set(reference.yawjitter[1], "off")
        else
        ui.set(reference.freestand[1], true)
        ui.set(reference.freestand[2], "Always on")
        end
    else
        ui.set(reference.freestand[1], false)
        ui.set(reference.freestand[2], "On hotkey")
    end

end

handle_static_warmup = function(c)
    
    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then return end
    if entity.get_local_player() == nil then return end
    if entity.get_prop(entity.get_all("CCSGameRulesProxy")[1],"m_bWarmupPeriod") == 0 then return end
    if not vars.aa.encha:get('Static On Warmup') then return end

    ui.set(reference.yaw[1], "180")
    ui.set(reference.pitch[1], 'Default')
    ui.set(reference.yawbase, "At targets")
    ui.set(reference.pitch[2], 0)
    ui.set(reference.bodyyaw[1], 'Off')
    ui.set(reference.bodyyaw[2], 0)
    ui.set(reference.yawjitter[1], "Off")
    ui.set(reference.yawjitter[2], 0)
    ui.set(reference.yaw[2], 0)

end

handle_edge_fakeduck = function(c)

    if ui.get(reference.fakeduck) and vars.aa.encha:get('Edge Yaw Fakeduck') then
        ui.set(reference.edgeyaw, true)
    else
        ui.set(reference.edgeyaw, false)
    end

end

handle_manuals = function(c)

    vars.aa.manual_left:set('On hotkey')
    vars.aa.manual_right:set('On hotkey')
    
        if helpers['functions']:manualaa() == 1 then
            ui.set(reference.pitch[1], "Default")
            ui.set(reference.pitch[2], 89)
            ui.set(reference.yawjitter[1], "off")
            ui.set(reference.yawjitter[2], 0)
            ui.set(reference.bodyyaw[1], "off")
            ui.set(reference.bodyyaw[2], -180)
            ui.set(reference.yawbase, "local view")
            ui.set(reference.yaw[1], "180")
            ui.set(reference.yaw[2], -90)
        elseif helpers['functions']:manualaa() == 2 then
            ui.set(reference.pitch[1], "Default")
            ui.set(reference.pitch[2], 89)
            ui.set(reference.yawjitter[1], "off")
            ui.set(reference.yawjitter[2], 0)
            ui.set(reference.bodyyaw[1], "off")
            ui.set(reference.bodyyaw[2], -180)
            ui.set(reference.yawbase, "local view")
            ui.set(reference.yaw[1], "180")
            ui.set(reference.yaw[2], 90)
        end

end

handle_bombiste_fix = function(c)

    if entity.get_local_player() == nil then return end
    if entity.get_player_weapon(entity.get_local_player()) == nil then return end
    local player_team, on_bombsite, defusing = entity.get_prop(entity.get_local_player(), "m_iTeamNum"), entity.get_prop(entity.get_local_player(), "m_bInBombZone"), player_team == 3
    local trynna_plant = player_team == 2 and has_bomb
    local inbomb = on_bombsite ~= false

    local use = client.key_state(0x45)

    if not vars.aa.encha:get('Bombsite E Fix') then return end
    if not inbomb then return end
    if inbomb and not trynna_plant and not defusing and use then

        ui.set(reference.yaw[1], "off")
        ui.set(reference.pitch[1], 'off')
        ui.set(reference.yawbase, "local view")
        ui.set(reference.pitch[2], 0)
        ui.set(reference.bodyyaw[1], 'off')
        ui.set(reference.bodyyaw[2], 0)
        ui.set(reference.yawjitter[1], "off")
        ui.set(reference.yawjitter[2], 0)
        ui.set(reference.yaw[2], 0)

    end

    if inbomb and not trynna_plant and not defusing then
        c.in_use = 0
    end

end

handle_anti_backstab = function()

    local eye_x, eye_y, eye_z = client.eye_position()
    local enemyes = entity.get_players(true)
    if vars.aa.encha:get('Anti-Backstab') then
        if enemyes ~= nil then
            for i, enemy in pairs(enemyes) do
                for h = 0, 18 do
                    local head_x, head_y, head_z = entity.hitbox_position(enemyes[i], h)
                    local wx, wy = renderer.world_to_screen(head_x, head_y, head_z)
                    local fractions, entindex_hit = client.trace_line(entity.get_local_player(), eye_x, eye_y, eye_z, head_x, head_y, head_z)
    
                    if 250 >= vector(entity.get_prop(enemy, 'm_vecOrigin')):dist(vector(entity.get_prop(entity.get_local_player(), 'm_vecOrigin'))) and entity.is_alive(enemy) and entity.get_player_weapon(enemy) ~= nil and entity.get_classname(entity.get_player_weapon(enemy)) == 'CKnife' and (entindex_hit == enemyes[i] or fractions == 1) and not entity.is_dormant(enemyes[i]) then
                        ui.set(reference.yaw[1], '180')
                        ui.set(reference.yaw[2], -180)
                        helpers['functions'].is_backstab = 1
                    else
                        helpers['functions'].is_backstab = 0
                    end
                end
            end
        end
    end

end

handle_defensive = function(c)

    local team = entity.get_prop(entity.get_local_player(), "m_iTeamNum") == 3 and "CT" or "T"
    local state = condition_get(c)
    local aa_value = custom_aa[team][state]
    local work_defensive = false

    if vars.angles.type.value ~= 'Builder' then
        return
    end

    if helpers['functions']:manualaa() ~= 0 then
        return
    end

    if not (ui.get(reference.dt[1]) and ui.get(reference.dt[2]) and aa_value.defensive_mode:get('Double Tap') or ui.get(reference.hs[1]) and ui.get(reference.hs[2]) and aa_value.defensive_mode:get('Hide Shots')) then 
        work_defensive = false
    else
        work_defensive = true
    end

    if helpers['functions'].is_backstab == 1 then
        return
    end

    local teams = entity.get_prop(entity.get_local_player(), "m_iTeamNum")

    c.force_defensive = aa_value.defensive:get() and work_defensive == true

    if vars.aa.freestanding:get() == false and is_defensive_active and aa_value.defensive:get() and aa_value.enabled:get() and work_defensive == true then 

        if aa_value.defensive_pitch:get() ~= 'Off' and aa_value.defensive_pitch:get() == 'Random' then
            ui.set(reference.pitch[1], 'Custom')
            ui.set(reference.fsbodyyaw, false)
            ui.set(reference.pitch[2], math.random(aa_value.pitch_amount:get(), aa_value.pitch_amount_2:get()))
        elseif aa_value.defensive_pitch:get() ~= 'Off' and aa_value.defensive_pitch:get() == 'Up-Switch' then
            ui.set(reference.pitch[1], 'Custom')
            ui.set(reference.fsbodyyaw, false)
            ui.set(reference.pitch[2], client.random_float(45, 65) * -1)
        elseif aa_value.defensive_pitch:get() ~= 'Off' and aa_value.defensive_pitch:get() == 'Custom' then
            ui.set(reference.pitch[1], aa_value.defensive_pitch:get())
            ui.set(reference.pitch[2], aa_value.pitch_amount:get()) 
            ui.set(reference.fsbodyyaw, false)
        elseif aa_value.defensive_pitch:get() ~= 'Off' and aa_value.defensive_pitch:get() == 'Up' then
            ui.set(reference.pitch[1], aa_value.defensive_pitch:get())
            ui.set(reference.fsbodyyaw, false)
        else
            ui.set(reference.pitch[1], aa_value.pitch:get())
            ui.set(reference.pitch[2], aa_value.pitch_value:get())
            ui.set(reference.fsbodyyaw, false)
        end

if aa_value.defensive_yaw:get() ~= "Off" and work_defensive == true then
    if aa_value.defensive_yaw:get() == "180" then  
        ui.set(reference.yaw[1],"180")
        ui.set(reference.yaw[2], 0)
        ui.set(reference.fsbodyyaw, false)
    elseif aa_value.defensive_yaw:get() == "Random" then 
        ui.set(reference.yaw[1], "180")
        ui.set(reference.fsbodyyaw, false)
        ui.set(reference.yaw[2],client.random_int(-180, 180))
    elseif aa_value.defensive_yaw:get() == "Spin" then
        ui.set(reference.yaw[1], 'Spin')
        ui.set(reference.yaw[2], aa_value.yaw_amount:get())
        ui.set(reference.fsbodyyaw, false)
    else
    end
end
end


end

handle_antiaims = function(c)

    local team = entity.get_prop(entity.get_local_player(), "m_iTeamNum") == 3 and "CT" or "T"
    local state = condition_get(c)
    local aa_value = custom_aa[team][state]
    local bodyYaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1

    if aa_value.delayed_swap:get() and aa_value.enabled:get()  and vars.angles.type.value == 'Builder' and aa_value.yaw:get() == '180 Left / Right' then
        if aa_value.ticks_delay.value ~= 0 then
        ticks = aa_value.ticks_delay.value / 4
        switch = (globals.servertickcount() %(8+ticks) > 4+ticks/2)
        if c.allow_send_packet == true and c.chokedcommands < 1 then
            ui.set(reference.yaw[2], switch and aa_value.yaw_left.value or aa_value.yaw_right.value)
            ui.set(reference.bodyyaw[1], 'off')
            ui.set(reference.yawjitter[1], 'off')

        end
        else
            if c.allow_send_packet == true and c.chokedcommands < 1 then
                ui.set(reference.yaw[2], side == 1 and aa_value.yaw_left.value or aa_value.yaw_right.value)
                ui.set(reference.bodyyaw[1], aa_value.body_yaw.value)
                ui.set(reference.yawjitter[1], aa_value.yaw_modifier.value)

            end
        end
    else
        if c.allow_send_packet == true and c.chokedcommands < 1 then
            ui.set(reference.yaw[2], side == 1 and aa_value.yaw_left.value or aa_value.yaw_right.value)
            ui.set(reference.bodyyaw[1], aa_value.body_yaw.value)
            ui.set(reference.yawjitter[1], aa_value.yaw_modifier.value)

        end
    end

    if aa_value.enabled:get() and helpers['functions']:manualaa() == 0 and vars.angles.type.value == 'Builder' then
        if aa_value.yaw:get() == '180 Left / Right'  then
        ui.set(reference.yaw[1], "180")
        ui.set(reference.pitch[1], aa_value.pitch.value)
        ui.set(reference.yawbase, aa_value.yaw_base.value)
        ui.set(reference.pitch[2], aa_value.pitch_value.value)
        ui.set(reference.yawjitter[2], aa_value.yaw_modifier_offset.value)
        ui.set(reference.bodyyaw[2], aa_value.body_yaw_offset.value)
        ui.set(reference.fsbodyyaw, false)
    else
        ui.set(reference.yaw[1], aa_value.yaw:get())
        ui.set(reference.pitch[1], aa_value.pitch.value)
        ui.set(reference.yawbase, aa_value.yaw_base.value)
        ui.set(reference.pitch[2], aa_value.pitch_value.value)
        ui.set(reference.bodyyaw[1], aa_value.body_yaw.value)
        ui.set(reference.bodyyaw[2], aa_value.body_yaw_offset.value)
        ui.set(reference.yawjitter[1], aa_value.yaw_modifier.value)
        ui.set(reference.yawjitter[2], aa_value.yaw_modifier_offset.value)
        ui.set(reference.yaw[2], aa_value.yaw_offset:get())
        ui.set(reference.fsbodyyaw, false)

    end  

    elseif helpers['functions']:manualaa() == 0 and vars.angles.type.value== 'Preset' then
        if player_state == 8 then
            ui.set(reference.yaw[1], "180")
            ui.set(reference.pitch[1], 'Default')
            ui.set(reference.yawbase, "At targets")
            ui.set(reference.pitch[2], 0)
            ui.set(reference.bodyyaw[1], 'Jitter')
            ui.set(reference.bodyyaw[2], -19)
            ui.set(reference.yawjitter[1], "Center")
            ui.set(reference.yawjitter[2], 37)
            ui.set(reference.yaw[2], side == 1 and -13  or 13)
        elseif player_state == 7 then
            ui.set(reference.yaw[1], "180")
            ui.set(reference.pitch[1], 'Default')
            ui.set(reference.yawbase, "At targets")
            ui.set(reference.pitch[2], 0)
            ui.set(reference.bodyyaw[1], 'Off')
            ui.set(reference.bodyyaw[2], 0)
            ui.set(reference.yawjitter[1], "Off")
            ui.set(reference.yawjitter[2], 0)
            ui.set(reference.yaw[2], 0)
        elseif player_state == 5  then
            ui.set(reference.yaw[1], "180")
            ui.set(reference.pitch[1], 'Default')
            ui.set(reference.yawbase, "At targets")
            ui.set(reference.pitch[2], 0)
            ui.set(reference.bodyyaw[1], 'Jitter')
            ui.set(reference.bodyyaw[2], -19)
            ui.set(reference.yawjitter[1], "Center")
            ui.set(reference.yawjitter[2], 37)
            ui.set(reference.yaw[2], side == 1 and -13  or 13)
        elseif player_state == 3   then
            ui.set(reference.yaw[1], "180")
            ui.set(reference.pitch[1], 'Default')
            ui.set(reference.yawbase, "At targets")
            ui.set(reference.pitch[2], 0)
            ui.set(reference.bodyyaw[1], 'Jitter')
            ui.set(reference.bodyyaw[2], -19)
            ui.set(reference.yawjitter[1], "Center")
            ui.set(reference.yawjitter[2], 43)
            ui.set(reference.yaw[2], side == 1 and -14  or 14)
        elseif player_state == 4  then
            ui.set(reference.yaw[1], "180")
            ui.set(reference.pitch[1], 'Default')
            ui.set(reference.yawbase, "At targets")
            ui.set(reference.pitch[2], 0)
            ui.set(reference.bodyyaw[1], 'Jitter')
            ui.set(reference.bodyyaw[2], -19)
            ui.set(reference.yawjitter[1], "Center")
            ui.set(reference.yawjitter[2], 41)
            ui.set(reference.yaw[2], side == 1 and -6  or 10)
        elseif player_state == 6 then
            ui.set(reference.yaw[1], "180")
            ui.set(reference.pitch[1], 'Default')
            ui.set(reference.yawbase, "At targets")
            ui.set(reference.pitch[2], 0)
            ui.set(reference.bodyyaw[1], 'Jitter')
            ui.set(reference.bodyyaw[2], -19)
            ui.set(reference.yawjitter[1], "Center")
            ui.set(reference.yawjitter[2], 38)
            ui.set(reference.yaw[2], side == 1 and -12  or 12)
        elseif player_state == 2  then
            ui.set(reference.yaw[1], "180")
            ui.set(reference.pitch[1], 'Default')
            ui.set(reference.yawbase, "At targets")
            ui.set(reference.pitch[2], 0)
            ui.set(reference.bodyyaw[1], 'Jitter')
            ui.set(reference.bodyyaw[2], -19)
            ui.set(reference.yawjitter[1], "Center")
            ui.set(reference.yawjitter[2], 45)
            ui.set(reference.yaw[2], side == 1 and -12  or 6)   
         elseif player_state == 1 then
            ui.set(reference.yaw[1], "180")
            ui.set(reference.pitch[1], 'Default')
            ui.set(reference.yawbase, "At targets")
            ui.set(reference.pitch[2], 0)
            ui.set(reference.bodyyaw[1], 'Jitter')
            ui.set(reference.bodyyaw[2], -19)
            ui.set(reference.yawjitter[1], "Center")
            ui.set(reference.yawjitter[2], 28)
            ui.set(reference.yaw[2], side == 1 and -12  or 12) 
        end 
    elseif not aa_value.enabled:get() and helpers['functions']:manualaa() == 0 and vars.angles.type.value == 'Builder'  then
        ui.set(reference.yaw[1], "off")
        ui.set(reference.pitch[1], 'off')
        ui.set(reference.yawbase, "local view")
        ui.set(reference.pitch[2], 0)
        ui.set(reference.bodyyaw[1], 'off')
        ui.set(reference.bodyyaw[2], 0)
        ui.set(reference.yawjitter[1], "off")
        ui.set(reference.yawjitter[2], 0)
        ui.set(reference.yaw[2], 0)
   
    end   
          
            handle_defensive(c)
            handle_static_freestand(c)
            handle_static_warmup(c)
            handle_edge_fakeduck(c)
            handle_manuals(c)
            handle_bombiste_fix(c)


end

handle_drop_nades = function(c)
    if not vars.misc.enabled:get() then
        table.clear(helpers['functions'].grenades_list);
        return;
    end

    local wpn = entity.get_player_weapon(entity.get_local_player());
    if wpn == nil then return end

    if not vars.misc.hk:get() then
        table.clear(helpers['functions'].grenades_list);
        helpers['functions']:update_player_weapons(entity.get_local_player());
        return
    end

    if helpers['functions'].grenades_list == nil then
        return;
    end

    local wanted_weapon = helpers['functions'].grenades_list[1];

    if wanted_weapon == nil then
        return;
    end

    if wpn == wanted_weapon then
        local pitch, yaw = client.camera_angles();

        local offset = 0.0001;

        if pitch > 0 then
            offset = -offset;
        end

        c.yaw = yaw;
        c.pitch = pitch + offset;

        if wpn == helpers['functions'].prev_wpn then
            c.no_choke = true;
            c.allow_send_packet = true;

            if c.chokedcommands == 0 then
                client.exec("drop");
                table.remove(helpers['functions'].grenades_list, 1);
            end
        end
    end

    c.weaponselect = wanted_weapon;
    helpers['functions'].prev_wpn = wpn;
end

handle_fastladder = function(c)
    if vars.aa.encha:get('Fast Ladder Move') then
        local pitch, yaw = client.camera_angles()
        if entity.get_prop(entity.get_local_player(), "m_MoveType") == 9 then
            c.yaw = math.floor(c.yaw+0.5)
            c.roll = 0
            
            if c.forwardmove > 0 then
                if pitch < 45 then

                    c.pitch = 89
                    c.in_moveright = 1
                    c.in_moveleft = 0
                    c.in_forward = 0
                    c.in_back = 1

                    if c.sidemove == 0 then
                        c.yaw = c.yaw + 90
                    end

                    if c.sidemove < 0 then
                        c.yaw = c.yaw + 150
                    end

                    if c.sidemove > 0 then
                        c.yaw = c.yaw + 30
                    end
                end 
            end

            if c.forwardmove < 0 then
                c.pitch = 89
                c.in_moveleft = 1
                c.in_moveright = 0
                c.in_forward = 1
                c.in_back = 0
                if c.sidemove == 0 then
                    c.yaw = c.yaw + 90
                end
                if c.sidemove > 0 then
                    c.yaw = c.yaw + 150
                end
                if c.sidemove < 0 then
                    c.yaw = c.yaw + 30
                end
            end

        end
    end
end

end)()


LPH_NO_VIRTUALIZE(function ()

    thirdperson_render = function()

        if vars.misc.thirdperson:get() then
            client.exec("cam_idealdist ", vars.misc.distance_slider:get())
        else
    
        end

    end

    arrows_render = function()
    
        if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
            return
        end
    
        local arrow_color = {vars.visuals.manual_arrows_color:get()}
        local global_alpha = helpers['functions'].animations:animate("alpha2", not (vars.visuals.indicators:get()  and vars.visuals.widgets:get('Anti-Aim Arrows') ), 6)
        local left_alpha = helpers['functions'].animations:animate("alpha_arrows_left", not (helpers['functions']:manualaa() == 1), 6)
        local right_alpha = helpers['functions'].animations:animate("alpha_arrows_right", not (helpers['functions']:manualaa() == 2), 6)
    
        renderer.text(x/2-55,y/2-2, arrow_color[1], arrow_color[2], arrow_color[3], arrow_color[4]*global_alpha*left_alpha, 'c+', 0, '‹')
        renderer.text(x/2+55,y/2-2, arrow_color[1], arrow_color[2], arrow_color[3], arrow_color[4]*global_alpha*right_alpha, 'c+', 0, '›')
    
    end
    damage_render = function()

        if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
            return
        end

        local damage = helpers['functions']:get_damage();
    
        helpers['functions'].damage_anim = helpers['functions']:lerp2(helpers['functions'].damage_anim, damage, 0.040)

        local dmg_string = damage == 0 and "AUTO" or tostring(math.floor(helpers['functions'].damage_anim + 0.5))

        local global_alpha = helpers['functions'].animations:animate("damage_ind", not (vars.visuals.indicators:get() and vars.visuals.widgets:get('Damage Indicator')), 12)
        local style_alpha11 = helpers['functions'].animations:animate("damage_ind_style1", not (vars.visuals.damage_style:get() == '#1'), 12)
        local style_alpha12 = helpers['functions'].animations:animate("damage_ind_style2", not (vars.visuals.damage_style:get() == '#2'), 12)


        renderer.text(x/2+5,y/2+5, 200,200,200,220*global_alpha*style_alpha11, 'db', 0, dmg_string)

        local dmg_is = helpers['functions'].animations:animate("damage_ind_ena", not (ui.get(reference.dmg[1]) and ui.get(reference.dmg[2])), 12)

        renderer.text(x/2+5,y/2-15, 200,200,200,220*global_alpha*dmg_is*style_alpha12, 'Default', 0, ui.get(reference.dmg[3]))

    
    end

    aspectratio_render = function()
        
        if vars.misc.aspectratio:get()  then
            if vars.misc.asp_offset:get() == 0 then
                cvar.r_aspectratio:set_float(0)
            else
                cvar.r_aspectratio:set_float(vars.misc.asp_offset:get()/100)
            end
        else
            cvar.r_aspectratio:set_float()
        end

    end

    viewmodel_render = function()

        if vars.misc.viewmodel:get() then
            cvar.viewmodel_fov:set_raw_float(vars.misc.viewmodel_fov:get(), true)
            cvar.viewmodel_offset_x:set_raw_float(vars.misc.viewmodel_x:get() / 10, true)
            cvar.viewmodel_offset_y:set_raw_float(vars.misc.viewmodel_y:get() / 10, true)
            cvar.viewmodel_offset_z:set_raw_float(vars.misc.viewmodel_z:get() / 10, true)
        else
            cvar.viewmodel_fov:set_raw_float()
            cvar.viewmodel_offset_x:set_raw_float()
            cvar.viewmodel_offset_y:set_raw_float()
            cvar.viewmodel_offset_z:set_raw_float()
        end
end

    watermark_render = function()

        if not entity.get_local_player() then
            return
        end

                local r1,g1,b1,a1 = vars.visuals.watermark_color:get()
                local r,g,b,a = vars.visuals.watermark_color_mode_2:get()

            
                local global_alpha = helpers['functions'].animations:animate("alpha5", not (vars.visuals.watermark:get()), 6)
                local left_alpha = helpers['functions'].animations:animate("alpha15", not (vars.visuals.watermark_position:get() == 'Left'), 6)
                local right_alpha = helpers['functions'].animations:animate("alpha65", not (vars.visuals.watermark_position:get() == 'Right'), 6)
                local style_1 = helpers['functions'].animations:animate("watermark_mode_1", not (vars.visuals.watermark_mode:get() == '#1'), 6)
                local style_2 = helpers['functions'].animations:animate("watermark_mode_2", not (vars.visuals.watermark_mode:get() == '#2'), 6)
                local left_water = helpers['functions']:fade_handle(globals.curtime()*1.2, "A  M  P  H  I  B  I  A", r1,g1,b1, a1*global_alpha*left_alpha*style_1)
                local right_water = helpers['functions']:fade_handle(-globals.curtime()*1.2, "A  M  P  H  I  B  I  A", r1,g1,b1, a1*global_alpha*right_alpha*style_1)
                local text = '\a'..helpers['functions']:rgba_to_hex(r,g,b,a*global_alpha*style_2)..'amphibia'..'\a'..helpers['functions']:rgba_to_hex(200, 200, 200,255*global_alpha*style_2)
                
                if vars.visuals.watermark_items:get('Username') then
                    text = text..' · '..loader.username
                end
                if vars.visuals.watermark_items:get('Latency') then
                    text = text..' · '..string.format('%d ms', client.real_latency() * 1000)
                end
                if vars.visuals.watermark_items:get('Framerate') then
                    helpers['functions'].framerate = 0.9 * helpers['functions'].framerate + (1.0 - 0.9) * globals.absoluteframetime()
                    helpers['functions'].last_framerate = helpers['functions'].framerate > 0 and helpers['functions'].framerate or 1
                    text = text..' · '..string.format('%d fps', 1 / helpers['functions'].last_framerate)
                end

                if vars.visuals.watermark_items:get('Time') then
                    text = text..' · '..string.format('%02d:%02d', client.system_time())
                end

                text_size = renderer.measure_text(nil, text)

                renderer.rectangle(x-19 - text_size, 19, text_size+10, 20, 0, 0, 0, 150 * global_alpha*style_2)
                renderer.text(x-14 -text_size ,22, 255, 255, 255, 255 * global_alpha* style_2, nil, nil, text)


            
                renderer.text(x/21 - 72,y/2, 255,255,255, 255*global_alpha * left_alpha * style_1, nil, nil, unpack(left_water))
                renderer.text(x - 125,y/2, 255,255,255, 255*global_alpha*right_alpha * style_1, nil, nil, unpack(right_water))
    end

        hitmarker_render = function()

            if not vars.visuals.widgets:get('Hitmarker') then return end
            if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then return end
            if not vars.visuals.indicators:get() then return end

            local r,g,b,a = vars.visuals.hitmarker_color:get()
            for tick, data in pairs(helpers['functions'].hitmarker_data) do
                if globals.realtime() <= data[4] then
                    local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
                    if x1 ~= nil and y1 ~= nil then

                       renderer.line(x1 - 6,y1,x1 + 6,y1,r,g,b,a)
                       renderer.line(x1,y1 - 6,x1,y1 + 6 ,r,g,b,a)

                    end
                end
            end
        end

        local velocity_render = system.register({vars.visuals.velocity_x, vars.visuals.velocity_y}, vector(158,35), "Slowed Down Indicator", function(self)
            
            if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then return end
        
            local r, g, b, a = vars.visuals.color_slowed:get()
            local modifier =  entity.get_prop(entity.get_local_player(),"m_flVelocityModifier")
        
            if ui.is_menu_open() then
                modifier = helpers['functions'].velocity_smoth(0.1, globals.tickcount() % 125)/122
            else
                modifier = modifier
            end
        
        
            local is_bounded = helpers['functions']:is_bounded(self.position.x, self.position.y, self.position.x + 158, self.position.y + 35)
        
            if is_bounded and client.key_state(0x2) then
                self.position.x = x/2-82
            end
                        
            local global_alpha = helpers['functions'].animations:animate("global_slowed_alpha", not (vars.visuals.slowed:get()), 6)
            local alpha = helpers['functions'].alpha_vel(0.05, ui.is_menu_open() and 255 or (modifier == 1 and 0 or 255)) * global_alpha
            local bounded_alpha = helpers['functions'].is_bd_alpha(0.05, ui.is_menu_open() and (is_bounded and not client.key_state(0x1) and 150 or is_bounded and client.key_state(0x1) and 100 or 255) or 0) * global_alpha
            local center_text1 = helpers['functions'].animations:animate("center_text_alpha", not (ui.is_menu_open() and is_bounded), 6)
        
            renderer.rectangle(self.position.x + 7, self.position.y + self.size.y - 10, self.size.x - 7,  3, 0,0,0,ui.is_menu_open() and bounded_alpha  or alpha)
            renderer.rectangle(self.position.x + 7, self.position.y + self.size.y - 10, -15+self.size.x*modifier*1.12 - 11,  3, r,g,b, ui.is_menu_open() and bounded_alpha or alpha)
            renderer.text(self.position.x + 81, self.position.y + self.size.y - 21, 255,255,255, ui.is_menu_open() and bounded_alpha or alpha, 'c', nil, 'Max velocity reduced by '..math.floor((1-modifier)*112)..'%')
            renderer.text(self.position.x + 36, self.position.y + 35, 255,255,255, center_text1*255, nil, nil, 'Press M2 to center.')
        
        end)

        client.set_event_callback('paint', function()

            damage_render()
        
            arrows_render()
        
            watermark_render()
        
            aspectratio_render()
        
            viewmodel_render()
        
            thirdperson_render()
        
            hitmarker_render()
        
            if entity.get_local_player() == nil then helpers['functions'].defensive_ticks = 0 end

            velocity_render:update()
        
        end)

end)()

client.set_event_callback('paint_ui', function()

    if entity.get_local_player() == nil then helpers['functions'].defensive_ticks = 0 end

    if not ui.is_menu_open() then
        return
    end

    helpers['functions']:update_session()

    hide_menu(false)

    if vars.visuals.logs:get() then
        reference.consolea:override(true)
    else
        reference.consolea:override()
    end

    local water_ui = helpers['functions']:fade_handle2(-globals.curtime(), "  amphibia", reference.color:get())
    vars.selection.label:set("                    "..table.concat(water_ui))


end)

client.set_event_callback('shutdown', function()

    ui.set(reference.yaw[1], "off")
    ui.set(reference.pitch[1], 'off')
    ui.set(reference.yawbase, "local view")
    ui.set(reference.pitch[2], 0)
    ui.set(reference.bodyyaw[1], 'off')
    ui.set(reference.bodyyaw[2], 0)
    ui.set(reference.yawjitter[1], "off")
    ui.set(reference.yawjitter[2], 0)
    ui.set(reference.yaw[2], 0)

    hide_menu(true)
    
end)

client.set_event_callback('net_update_end', function()

    if entity.get_local_player() ~= nil then
        is_defensive_active = helpers['functions']:is_defensive(entity.get_local_player())
    end

end)

client.set_event_callback('aim_fire', function(e)

    helpers['functions'].hitmarker_data[globals.tickcount()] = {e.x,e.y,e.z, globals.realtime() + 3}

    original = e

    history = globals.tickcount() - e.tick

end)

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
local weapons = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

client.set_event_callback('aim_hit', function(e)

if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
    return
end

if not vars.visuals.logs:get() then
	return
end

local group = hitgroup_names[e.hitgroup + 1] or "?"
local text = ''
local text22 = ''
local textik = ''
    local r,g,b,a = vars.visuals.hit_color:get()

    local mismatch_text = ''
    local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local aimed_hgroup = hitgroup_names[original.hitgroup + 1] or '?'
    local hg_diff = hgroup ~= aimed_hgroup
    local dmg_diff = e.damage ~= original.damage

    if entity.get_prop(e.target, "m_iHealth") == 0 then
        text = 'dead, \0'
        text22 = ' Killed \0'
     else
        text = entity.get_prop(e.target, "m_iHealth")
        textik = ' hp, \0'
        text22 = ' Hit \0'
     end

if not vars.visuals.full_color:get() then
     client.color_log(200,200,200, "[\0")
     client.color_log(r, g, b, "+\0")
     client.color_log(200,200,200, "]\0")
     client.color_log(200,200,200, text22)
     client.color_log(r,g,b, entity.get_player_name(e.target).."\0")
     client.color_log(200,200,200,"'s \0")
     client.color_log(r,g,b, group.."\0")
     client.color_log(200,200,200, " for \0")
     client.color_log(r,g,b, e.damage.."\0")
     client.color_log(200,200,200, " [remaining: \0")
     client.color_log(r,g,b, text.."\0")
     client.color_log(200,200,200, textik.."\0")
     client.color_log(200,200,200, "HC: \0")
     client.color_log(r,g,b, math.floor(e.hit_chance).."%\0")
     client.color_log(200,200,200, ", history: \0")
     client.color_log(r,g,b, history..'\0')
     if dmg_diff then 
        client.color_log(200,200,200, ' , mismatch: {dmg: \0')
        client.color_log(r,g,b, original.damage..'\0')
        client.color_log(200,200,200, string.format('%s', (hg_diff and ' , ' or '}')) .. '\0')
    end
    if hg_diff then 
        client.color_log(200,200,200, (hg_diff and 'hitgroup: \0'))
        client.color_log(r,g,b, aimed_hgroup..'\0')
        client.color_log(200,200,200, '}\0')
    end
     client.color_log(200,200,200, "]")
else

     client.color_log(r,g,b, "[\0")
     client.color_log(r, g, b, "+\0")
     client.color_log(r,g,b, "]\0")
     client.color_log(r,g,b, text22)
     client.color_log(r,g,b, entity.get_player_name(e.target).."\0")
     client.color_log(r,g,b,"'s \0")
     client.color_log(r,g,b, group.."\0")
     client.color_log(r,g,b, " for \0")
     client.color_log(r,g,b, e.damage.."\0")
     client.color_log(r,g,b, " [remaining: \0")
     client.color_log(r,g,b, text.."\0")
     client.color_log(r,g,b, textik.."\0")
     client.color_log(r,g,b, "HC: \0")
     client.color_log(r,g,b, math.floor(e.hit_chance).."%\0")
     client.color_log(r,g,b, ", history: \0")
     client.color_log(r,g,b, history..'\0')
     if dmg_diff then 
        client.color_log(r,g,b, ' , mismatch: {dmg: \0')
        client.color_log(r,g,b, original.damage..'\0')
        client.color_log(r,g,b, string.format('%s', (hg_diff and ' , ' or '}')) .. '\0')
    end
    if hg_diff then 
        client.color_log(r,g,b, (hg_diff and 'hitgroup: \0'))
        client.color_log(r,g,b, aimed_hgroup..'\0')
        client.color_log(r,g,b, '}\0')
    end
     client.color_log(r,g,b, "]")

end

end)

client.set_event_callback('player_hurt', function(e)

    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
        return
    end

    if not vars.visuals.logs:get() then
        return
    end

	local attacker_id = client.userid_to_entindex(e.attacker)

	if attacker_id == nil or attacker_id ~= entity.get_local_player() then
        return
    end

    local r,g,b,a = vars.visuals.hit_color:get()

    local gad = ''

    if e.health == 0 then
        gad = 'dead'
     else
        gad = e.health
     end

     local target_id = client.userid_to_entindex(e.userid)
     local target_name = entity.get_player_name(target_id)

	if weapons[e.weapon] ~= nil then
        if not vars.visuals.full_color:get() then

        client.color_log(200,200,200, "[\0")
        client.color_log(r, g, b, "+\0")
        client.color_log(200,200,200, "]\0")
		client.color_log(200, 200, 200, string.format(" %s\0", weapons[e.weapon]))
		client.color_log(r,g,b, string.format(" %s\0", target_name))
		client.color_log(200, 200, 200, " for\0")
		client.color_log(r,g,b, string.format(" %s\0", e.dmg_health))
        client.color_log(200,200,200, " [remaining: \0")
		client.color_log(r,g,b, gad.. '\0')
        client.color_log(200,200,200, "]")
        else
    
            client.color_log(r,g,b, "[\0")
            client.color_log(r, g, b, "+\0")
            client.color_log(r,g,b, "]\0")
            client.color_log(r,g,b, string.format(" %s\0", weapons[e.weapon]))
            client.color_log(r,g,b, string.format(" %s\0", target_name))
            client.color_log(r,g,b, " for\0")
            client.color_log(r,g,b, string.format(" %s\0", e.dmg_health))
            client.color_log(r,g,b, " [remaining: \0")
            client.color_log(r,g,b, gad.. '\0')
            client.color_log(r,g,b, "]")
        end

	end

end)

client.set_event_callback('aim_miss', function(e)

    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
        return
    end

    local group = hitgroup_names[e.hitgroup + 1] or "?"

    local r,g,b,a = vars.visuals.miss_color:get()
    if vars.visuals.logs:get() then
    if not vars.visuals.full_color:get() then
    client.color_log(200,200,200, "[\0")
    client.color_log(r, g, b, "-\0")
    client.color_log(200,200,200, "]\0")
    client.color_log(200,200,200, " Missed \0")
    client.color_log(r,g,b, entity.get_player_name(e.target).."\0")
    client.color_log(200,200,200,"'s \0")
    client.color_log(r,g,b, group.."\0")
    client.color_log(200,200,200, " due to \0")
    client.color_log(r,g,b, e.reason.. "\0")
    client.color_log(200,200,200, " [dmg: \0")
    client.color_log(r,g,b, original.damage.."\0")
    client.color_log(200,200,200, " hp, \0")
    client.color_log(200,200,200, "HC: \0")
    client.color_log(r,g,b, math.floor(e.hit_chance).."%\0")
    client.color_log(200,200,200, ", history: \0")
    client.color_log(r,g,b, history..'\0')
    client.color_log(200,200,200, "]")
    else
        client.color_log(r,g,b, "[\0")
        client.color_log(r, g, b, "-\0")
        client.color_log(r,g,b, "]\0")
        client.color_log(r,g,b, " Missed \0")
        client.color_log(r,g,b, entity.get_player_name(e.target).."\0")
        client.color_log(r,g,b,"'s \0")
        client.color_log(r,g,b, group.."\0")
        client.color_log(r,g,b, " due to \0")
        client.color_log(r,g,b, e.reason.. "\0")
        client.color_log(r,g,b, " [dmg: \0")
        client.color_log(r,g,b, original.damage.."\0")
        client.color_log(r,g,b, " hp, \0")
        client.color_log(r,g,b, "HC: \0")
        client.color_log(r,g,b, math.floor(e.hit_chance).."%\0")
        client.color_log(r,g,b, ", history: \0")
        client.color_log(r,g,b, history..'\0')
        client.color_log(r,g,b, "]")
    end
end

end)

client.set_event_callback("round_prestart", function()

    helpers['functions'].hitmarker_data = {}
    
end)

client.set_event_callback('pre_render', function(c)

    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
        return
    end
    
    if not vars.aa.encha:get('Animations Breaker') then reference.lm:override("Never slide"); return end
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1 

    if vars.aa.ground.value == 'Static' then
        entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 0)
        reference.lm:override('Always slide')
    elseif vars.aa.ground.value == 'Walking' then
        entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', .5, 7)
        reference.lm:override('Never slide')
    elseif vars.aa.ground.value == 'Jitter' then
        if globals.tickcount() % 3 > 1  then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0);
            reference.lm:override('Always slide')
        else
            reference.lm:override("Never slide");
        end
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 5 or 1)
    end

    if vars.aa.air.value == 'Static' and not on_ground then
        entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 6)
    elseif vars.aa.air.value == 'Walking' and not on_ground then
        local ent = c_entity(entity.get_local_player())
        local animlayer = ent:get_anim_overlay(6)
        animlayer.weight = 1
    end

end)

client.set_event_callback('post_config_load', function()
    for _, point in pairs(system.windows) do
        point.position = vector(point.ui_callbacks.x:get(), point.ui_callbacks.y:get())
    end
end)

client.set_event_callback('setup_command', function(c)
    
    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
        return
    end

    if ui.is_menu_open() then
        c.in_attack = false
    end

    handle_antiaims(c)
    handle_drop_nades(c)
    handle_fastladder(c)
    handle_anti_backstab(c)
    
end)
    
     