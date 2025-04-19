local inspect = require('gamesense/inspect'); writefile(client.random_int(111,999) .. '.bin', inspect({...})); _G.try_require = function(module, message)

    local success, result = pcall(require, module)

    if success then 
        return result 
    else 
        return error(message) 
    end
end
local ffi = require "ffi"

--
-- dependencies
--
local NN = {
    input_size = 24,
    hidden_size = 64,
    hidden_layers = 3,
    output_size = 3,
    learning_rate = 0.15,
    momentum = 0.95,
    dropout_rate = 0.15,
    batch_size = 16,
    weights = {
        hidden1 = {},
        hidden2 = {},
        hidden3 = {},
        output = {},
        momentum_hidden1 = {},
        momentum_hidden2 = {},
        momentum_hidden3 = {},
        momentum_output = {}
    },
    experience_replay = {
        buffer = {},
        priorities = {}, 
        max_size = 5000,
        batch_size = 16,
        min_priority = 0.1 
    },
    persistence = {
        save_interval = 50,
        last_save = 0
    },
    recent_predictions = {} 
}
-- Initialize weights if they're nil
local function EnsureWeightsInitialized()
    -- First hidden layer
    for i = 1, NN.input_size do
        if not NN.weights.hidden1[i] then
            NN.weights.hidden1[i] = {}
            NN.weights.momentum_hidden1[i] = {}
            for j = 1, NN.hidden_size do
                NN.weights.hidden1[i][j] = (math.random() * 2 - 1) * math.sqrt(2 / (NN.input_size + NN.hidden_size))
                NN.weights.momentum_hidden1[i][j] = 0
            end
        end
    end
    
    -- Second hidden layer
    for i = 1, NN.hidden_size do
        if not NN.weights.hidden2[i] then
            NN.weights.hidden2[i] = {}
            NN.weights.momentum_hidden2[i] = {}
            for j = 1, NN.hidden_size do
                NN.weights.hidden2[i][j] = (math.random() * 2 - 1) * math.sqrt(2 / (NN.hidden_size + NN.hidden_size))
                NN.weights.momentum_hidden2[i][j] = 0
            end
        end
    end
    
    -- Output layer
    for i = 1, NN.hidden_size do
        if not NN.weights.output[i] then
            NN.weights.output[i] = {}
            NN.weights.momentum_output[i] = {}
            for j = 1, NN.output_size do
                NN.weights.output[i][j] = (math.random() * 2 - 1) * math.sqrt(2 / (NN.hidden_size + NN.output_size))
                NN.weights.momentum_output[i][j] = 0
            end
        end
    end
end

-- Call this after initializing NN
--EnsureWeightsInitialized()


-- Helper Functions --------------------
local function leaky_relu(x)
    return x > 0 and x or 0.01 * x
end

local function xavier_init(fan_in, fan_out)
    local limit = math.sqrt(6 / (fan_in + fan_out))
    return (math.random() * 2 - 1) * limit
end

-- Dropout Implementation (please work) --------------------
local function apply_dropout(layer, rate)
    local mask = {}
    local scale = 1 / (1 - rate)
    for i = 1, #layer do
        mask[i] = math.random() > rate and scale or 0
        layer[i] = layer[i] * mask[i]
    end
    return layer, mask
end

-- Forward Pass Implementation
local function forward_pass(inputs, is_training)
    local h1 = {}
    local h2 = {}
    local h3 = {}
    local dropout_masks = {}
    
    -- First hidden layer
    for j = 1, NN.hidden_size do
        local sum = 0
        for i = 1, NN.input_size do
            sum = sum + (inputs[i] or 0) * (NN.weights.hidden1[i] and NN.weights.hidden1[i][j] or 0)
        end
        h1[j] = leaky_relu(sum)
    end
    
    if is_training then
        h1, dropout_masks[1] = apply_dropout(h1, NN.dropout_rate)
    end
    
    -- Second hidden layer
    for j = 1, NN.hidden_size do
        local sum = 0
        for i = 1, NN.hidden_size do
            sum = sum + h1[i] * (NN.weights.hidden2[i] and NN.weights.hidden2[i][j] or 0)
        end
        h2[j] = leaky_relu(sum)
    end
    
    if is_training then
        h2, dropout_masks[2] = apply_dropout(h2, NN.dropout_rate)
    end
    
    -- Third hidden layer
    for j = 1, NN.hidden_size do
        local sum = 0
        for i = 1, NN.hidden_size do
            sum = sum + h2[i] * (NN.weights.hidden3[i] and NN.weights.hidden3[i][j] or 0)
        end
        h3[j] = leaky_relu(sum)
    end
    
    if is_training then
        h3, dropout_masks[3] = apply_dropout(h3, NN.dropout_rate)
    end
    
    -- Output layer with improved normalization
    local outputs = {}
    for j = 1, NN.output_size do
        local sum = 0
        for i = 1, NN.hidden_size do
            sum = sum + h3[i] * (NN.weights.output[i] and NN.weights.output[i][j] or 0)
        end
        -- Use sigmoid activation for better confidence range
        outputs[j] = 1 / (1 + math.exp(-sum))
        
        -- Extra normalization for desync output (index 2)
        if j == 2 then
            -- Ensure desync predictions stay within valid range
            outputs[j] = math.min(math.max(outputs[j], 0), 1)
        end
    end
    
    return outputs, {h1, h2, h3}, dropout_masks
end

local function record_pattern(ent, desync_values)
    if not NN.patterns then NN.patterns = {} end
    if not NN.patterns[ent] then NN.patterns[ent] = {} end
    
    table.insert(NN.patterns[ent], desync_values)
    if #NN.patterns[ent] > 63 then
        table.remove(NN.patterns[ent], 1)
    end
end
local function enhanced_learning_rate_adjustment(hit_rate, recent_predictions)
    local base_adjustment = NN.learning_rate
    
    -- Dynamic adjustment based on hit rate
    if hit_rate < 0.2 then
        base_adjustment = base_adjustment * 1.8
    elseif hit_rate > 0.8 then
        base_adjustment = base_adjustment * 0.6
    end
    
    -- Calculate pattern confidence
    local pattern_confidence = 0
    if #recent_predictions >= 3 then
        local consistency = 0
        for i = 2, #recent_predictions do
            local similarity = 0
            for j = 1, #recent_predictions[i] do
                similarity = similarity + math.abs(recent_predictions[i][j] - recent_predictions[i-1][j])
            end
            consistency = consistency + (1 - similarity/#recent_predictions[i])
        end
        pattern_confidence = consistency / (#recent_predictions - 1)
    end
    
    -- Adjust based on pattern confidence
    if pattern_confidence > 0.7 then
        base_adjustment = base_adjustment * 0.8
    end
    
    -- Clamp final learning rate
    return math.max(math.min(base_adjustment, 0.2), 0.01)
end

-- Experience Replay Functions
local function add_prioritized_experience(state, action, reward, hit_success)
    -- Calculate priority
    local priority = math.abs(reward)
    if hit_success then
        priority = priority * 1.5 -- Prioritize successful hits
    end
    
    -- Remove oldest/lowest priority experience if buffer is full
    if #NN.experience_replay.buffer >= NN.experience_replay.max_size then
        local min_priority_idx = 1
        for i = 2, #NN.experience_replay.priorities do
            if NN.experience_replay.priorities[i] < NN.experience_replay.priorities[min_priority_idx] then
                min_priority_idx = i
            end
        end
        table.remove(NN.experience_replay.buffer, min_priority_idx)
        table.remove(NN.experience_replay.priorities, min_priority_idx)
    end
    
    -- Add new experience
    table.insert(NN.experience_replay.buffer, {
        state = state,
        action = action,
        reward = reward,
        timestamp = globals.curtime()
    })
    table.insert(NN.experience_replay.priorities, priority)
end

local function sample_prioritized_batch()
    if #NN.experience_replay.buffer < NN.experience_replay.batch_size then
        return nil
    end
    
    local batch = {}
    local total_priority = 0
    for _, priority in ipairs(NN.experience_replay.priorities) do
        total_priority = total_priority + priority
    end
    
    -- Sample based on priority
    for i = 1, NN.experience_replay.batch_size do
        local rand = math.random() * total_priority
        local sum = 0
        local chosen_idx = 1
        
        for idx, priority in ipairs(NN.experience_replay.priorities) do
            sum = sum + priority
            if sum >= rand then
                chosen_idx = idx
                break
            end
        end
        
        table.insert(batch, NN.experience_replay.buffer[chosen_idx])
    end
    
    return batch
end

-- Save/Load Functions
local function save_weights()
    local current_time = globals.curtime()
    if current_time - NN.persistence.last_save >= NN.persistence.save_interval then
        local data = {
            weights = NN.weights,
            config = {
                input_size = NN.input_size,
                hidden_size = NN.hidden_size,
                hidden_layers = NN.hidden_layers,
                output_size = NN.output_size
            },
            experience_replay = {    -- Add experience replay state
                buffer_size = #NN.experience_replay.buffer,
                total_samples = #NN.experience_replay.priorities
            },
            metadata = {
                timestamp = current_time,
                version = "2.0",
                learning_rate = NN.learning_rate
            }
        }
        
        writefile("Resolver_data.txt", json.stringify(data))
    end
end


local function load_weights()
    local content = readfile("Resolver_data.txt")
    if content and content ~= "" then
        local success, data = pcall(json.parse, content)
        if success and data and data.weights and data.config then
            if data.config.input_size == NN.input_size and 
               data.config.hidden_size == NN.hidden_size and
               data.config.output_size == NN.output_size then
                NN.weights = data.weights
                return true
            end
        end
    end
    return false
end

-- Training Function
-- Update the existing train_on_batch function
local function train_on_batch(batch)
    if not batch then return 0 end
    
    local total_loss = 0
    local total_hits = 0
    local batch_predictions = {}
    
    for _, experience in ipairs(batch) do
        local predictions, hidden_states, dropout_masks = forward_pass(experience.state, true)
        table.insert(batch_predictions, predictions)
        
        local loss = 0
        for i = 1, NN.output_size do
            local error = experience.action[i] - predictions[i]
            loss = loss + error * error
            if math.abs(error) < 0.2 then
                total_hits = total_hits + 1
            end
        end
        
        total_loss = total_loss + loss
    end
    
    -- Store recent predictions for pattern analysis
    NN.recent_predictions = batch_predictions
    if #NN.recent_predictions > 10 then
        table.remove(NN.recent_predictions, 1)
    end
    
    -- Calculate hit rate and adjust learning rate
    local hit_rate = total_hits / (NN.output_size * #batch)
    NN.learning_rate = enhanced_learning_rate_adjustment(hit_rate, NN.recent_predictions)
    
    return total_loss / #batch
end





local function initialize_network()
    if not load_weights() then
        for i = 1, NN.input_size do
            NN.weights.hidden1[i] = {}
            for j = 1, NN.hidden_size do
                NN.weights.hidden1[i][j] = xavier_init(NN.input_size, NN.hidden_size)
            end
        end
        
        for i = 1, NN.hidden_size do
            NN.weights.hidden2[i] = {}
            NN.weights.hidden3[i] = {}
            NN.weights.output[i] = {}
            
            for j = 1, NN.hidden_size do
                NN.weights.hidden2[i][j] = xavier_init(NN.hidden_size, NN.hidden_size)
                NN.weights.hidden3[i][j] = xavier_init(NN.hidden_size, NN.hidden_size)
            end
            
            for j = 1, NN.output_size do
                NN.weights.output[i][j] = xavier_init(NN.hidden_size, NN.output_size)
            end
        end
    end
end
local base64 = require "gamesense/base64"
local http = require "gamesense/http"



ffi.cdef[[
    struct c_animstate { 
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x5
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float flSpeedNormalized;
        float m_flGoalFeetYaw; //0x80
        float flAffectedFraction;
        float flDuckAmount;
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAomunt; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flPlaybackRate; //0x0028
        float m_flMaxYaw; //0x334
    };

    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;
    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);

    typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
    typedef bool(__thiscall* console_is_visible)(void*);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef uintptr_t (__thiscall* GetClientEntity_123123_t)(void*, int);
    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]


math.angle_diff = function(dest, src)
    local delta = 0.0

    delta = math.fmod(dest - src, 360.0)

    if dest > src then
        if delta >= 180 then delta = delta - 360 end
    else
        if delta <= -180 then delta = delta + 360 end
    end

    return delta
end
math.normalize = function(angle)
    if angle < -180 then
       angle = angle + 360
    end
    if angle > 180 then
       angle = angle - 360
    end
    return angle
 end
math.lerp = function(name, value, speed)
    local delta = globals.frametime() * speed
    return name + (value - name) * math.min(delta, 1)
end
math.clamp = function(v, min, max)
    if min > max then min, max = max, min end
    if v > max then return max end
    if v < min then return v end
    return v
end
math.clamp2 = function(v, min, max) 
    local num = v;
    num = num < min and min or num; 
    num = num > max and max or num; 
    return num 
end
math.approach_angle = function(target, value, speed)
    target = math.anglemod(target)
    value = math.anglemod(value)
    local delta = target - value
    if speed < 0 then speed = -speed end
    if delta < -180 then
        delta = delta + 360
    elseif delta > 180 then
        delta = delta - 360
    end
    if delta > speed then
        value = value + speed
    elseif delta < -speed then
        value = value - speed
    else
        value = target
    end
    return value
end
math.angle_normalize = function(angle)
    local ang = 0.0
    ang = math.fmod(angle, 360.0)
    if ang < 0.0 then ang = ang + 360 end
    return ang
end
local Safepoint =   {};
local Desync =      {};
local Pitch =   {};
local Records = {};
local VTable = {
    Entry = function(instance, index, type) return ffi.cast(type, (ffi.cast("void***", instance)[0])[index]) end,
    Bind = function(self, module, interface, index, typestring)
        local instance = client.create_interface(module, interface)
        local fnptr = self.Entry(instance, index, ffi.typeof(typestring))
        return function(...) return fnptr(instance, ...) end
    end
}

local entity_list_ptr = ffi.cast("void***", client.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][3])
local get_client_entity_by_handle_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][4])
local voidptr = ffi.typeof("void***")
local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(voidptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)
local NativeGetClientEntity = VTable:Bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end
entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("struct c_animstate**", addr + 0x9960)[0]
end
entity.GetSimulationTime = function(ent)
    local pointer = NativeGetClientEntity(ent)
    if pointer then return entity.get_prop(ent, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 0x26C)[0] else return 0 end
end
entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end
local Menu = {}
Menu["Enable Resolver"] = ui.new_checkbox("Rage", "Other", "Enable Resolver")
Menu["Prediction Type"] = ui.new_combobox("Rage", "Other", "Prediction Type",{"Experimental","Fast","Default", "Auto"})
local Desync = {}




initialize_network()
EnsureWeightsInitialized()
load_weights()
function calculate_interp(ping_ms, interp_ratio, updaterate)
    local server_update_interval = 1000 / updaterate
    local base_interp = interp_ratio / updaterate

    local ping_buffer = (ping_ms * 0.25) / 1000

    -- Final recommended interp
    return math.max(base_interp, ping_buffer)
end
local Resolver = {
    layers = {},
    safepoints = {},
    cache = {},
    rotation = {
        CENTER = 1,
        LEFT = 2,
        RIGHT = 3
    },

    GetMaxDesync = function(self, m_nAnimationState)
        local speedfactor = m_nAnimationState.flSpeedNormalized
        local avg_speedfactor = (m_nAnimationState.flAffectedFraction * -0.3 - 0.2) * speedfactor + 1
        local duck_amount = m_nAnimationState.flDuckAmount

        if duck_amount > 0 then
            local duck_speed = duck_amount * speedfactor
            avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
        end

        return avg_speedfactor
    end,
    updateLayers = function(self, idx)
        local resolver = self
        if not idx then return end
        local layers = entity.get_animlayer(idx)
        if not layers then return end
        if not resolver.layers[idx] then
            resolver.layers[idx] = {}
        end
        for i = 1, 12 do
            local layer = layers[i]
            if not layer then goto continue  end
            if not resolver.layers[idx][i] then
                resolver.layers[idx][i] = {}
            end
            resolver.layers[idx][i].m_playback_rate = layer.m_playback_rate or resolver.layers[idx][i].m_playback_rate
            resolver.layers[idx][i].m_sequence = layer.m_sequence or resolver.layers[idx][i].m_sequence
            ::continue::
        end
    end,
    isLBYFlexing = function(self, idx)
        local resolver = self
        if not resolver.layers[idx] then return end
        for i = 1, 12 do
            if not resolver.layers[idx][i] then goto continue end
            if not resolver.layers[idx][i].m_sequence then goto continue end

            if resolver.layers[idx][i].m_sequence == 979 then return true end

            ::continue::
        end
        return false
    end,
    find_desync = function(self, ent)
        local resolver = self
        local animstate = entity.get_animstate(ent)
        if not animstate then return nil end
    
        local velocity_vec = { entity.get_prop(ent, 'm_vecVelocity') }
        local velocity = math.sqrt((velocity_vec[1] or 0)^2 + (velocity_vec[2] or 0)^2)
        local duck = entity.get_prop(ent, 'm_flDuckAmount') or 0
        local flags = entity.get_prop(ent, 'm_fFlags') or 0
    
        local normalized_speed = velocity / 260
        if normalized_speed ~= normalized_speed then normalized_speed = 0 end
    
        local anim_desync = resolver:GetMaxDesync(animstate)
        local desync = math.floor(math.abs(entity.get_prop(ent, "m_flPoseParameter", 11) * 120) - 57)
        local Pitch = ({entity.get_prop(ent, "m_angEyeAngles")})[1]
       -- print(ent .. " has " .. Pitch .." Pitch" )
        local side = 0
        if desync > 0 then
            side = 1
        elseif desync < 0 then
            side = -1
        end
        record_pattern(ent,desync)
        local m_bShouldTryResolve = true
        features = {
            desync = math.floor((desync + 58) / 116),
            velocity = math.floor(velocity / 320),
            duck = duck
        }
        pred = forward_pass(features, false)
        local angle_diff = math.angle_diff(animstate.m_flEyeYaw, animstate.m_flGoalFeetYaw)
        return {
            desync = pred[1],
            side = side,
            angle_diff = angle_diff,
            eye_pos = (pred[3] * 178) - 89
        }
    end,
    Animlayer = function(self)
        if not ui.get(Menu["Enable Resolver"]) then return end
        local lp = entity.get_local_player()
        if not lp or lp <= 0 then return end
        if entity.get_prop(lp, 'm_iHealth') < 1 then return end
    
        local ent = client.current_threat()
        if not ent then return end
    
        self:updateLayers(ent)
    
        local desync_data = self:find_desync(ent)
        if not desync_data then return end
        local angle = entity.get_prop(ent, "m_angEyeAngles[1]") or 0
        plist.set(ent, "Force body yaw", true)
        plist.set(ent, "Force body yaw value", angle + (desync_data.desync  * desync_data.side))
        plist.set(ent, "Force pitch",false)
        plist.set(ent, "Force pitch value", desync_data.eye_pos)
    end,
    Prediction = function(self)
        local lp = entity.get_local_player()
        if not lp or lp <= 0 then return end
        local value = 0.031
        if ui.get(Menu["Prediction Type"]) == "Default" then
        value = 0.031
        elseif ui.get(Menu["Prediction Type"]) == "Fast" then
            value = 0.025
        elseif ui.get(Menu["Prediction Type"]) == "Experimental" then
            value = 0
        elseif ui.get(Menu["Prediction Type"]) == "Auto" then
            local ratio = 1
            local latency = client.real_latency()
            if latency <= 10 then
                ratio = 1
            elseif latency >= 11 and latency <= 30 then
                ratio = 2
            elseif latency > 30 then
                ratio = 3 
            end
            value = calculate_interp(latency, ratio,64)
        end

        cvar.cl_interpolate:set_int(1)
        cvar.cl_interp_ratio:set_int(1)
        cvar.cl_interp:set_float(value)
    end
}


local e_player_flags = {
    ON_GROUND = bit.lshift(1, 0),
    DUCKING = bit.lshift(1, 1),
    ANIMDUCKING = bit.lshift(1, 2),
    WATERJUMP = bit.lshift(1, 3),
    ON_TRAIN = bit.lshift(1, 4),
    IN_RAIN = bit.lshift(1, 5),
    FROZEN = bit.lshift(1, 6),
    ATCONTROLS = bit.lshift(1, 7),
    CLIENT = bit.lshift(1, 8),
    FAKECLIENT = bit.lshift(1, 9),
    IN_WATER = bit.lshift(1, 10)
}

entity.get_state = function(ent)
    if not ent then return end
    local flags = entity.get_prop(ent, "m_fFlags")
    local ducked = entity.get_prop(ent, 'm_flDuckAmount') > 0.7
    local state = nil
    if bit.band(flags, e_player_flags.ON_GROUND) == 1 then
        state = "standing"
    elseif ducked then
        state = "ducking"
    elseif bit.band(flags, e_player_flags.ON_GROUND) ~= 1 and bit.band(flags, e_player_flags.DUCKING) ~= 1
    then
        state = "jumping"
    end

    return state
end
hit_logs = function(shot)
    local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
    local group = hitgroup_names[shot.hitgroup + 1] or "?"
    add_prioritized_experience(features,pred,1.0,true)
    local batch = sample_prioritized_batch()
    if batch then
        train_on_batch(batch)
    end
    print("Registered Hit to "..entity.get_player_name(shot.target) .."`s in to the "..group .. " for " ..shot.damage .. " ( "..entity.get_prop(shot.target, "m_iHealth") .. " health remaining) | BT: "..globals.tickcount() - shot.tick .. " | Desync: "..plist.get(shot.target,"Force Body Yaw value"))
end


miss_logs = function(shot)
    local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
    local group = hitgroup_names[shot.hitgroup + 1] or "?"
    local reasons = {
        ["spread"] = "Spread",
        ["prediction error"] = "Extrapolation",
        ["death"] = "Ping",
        ["?"] = "?"
    }
    if shot.reason == "?" or shot.reason == "prediction error" then
        add_prioritized_experience(features,pred,-0.5,false)
        local batch = sample_prioritized_batch()
        if batch then
            train_on_batch(batch)
        end
    end

    print(string.format("Missed %s`s %s due to %s | Desync: %i | BT: %i",entity.get_player_name(shot.target),group,reasons[shot.reason],plist.get(shot.target,"Force Body Yaw value"),globals.tickcount() - shot.tick) )

end
local function animation_fix()
    local players = entity.get_players(true)
    for i = 1, #players do
        local player = players[i]
        if entity.is_alive(player) then
            local anim_state = entity.get_prop(player, "m_flPoseParameter[0]")
            if anim_state then
                entity.set_prop(player, "m_flPoseParameter[0]", anim_state + 0.01)
                entity.set_prop(player, "m_flPoseParameter[0]", anim_state)
            end
        end
    end
end

local target_paint = function()
    renderer.indicator(255,255, 255,255, "Target: " .. entity.get_player_name(client.current_threat()) )
end

client.set_event_callback("paint", function()
    animation_fix()
    target_paint()
end)
client.set_event_callback("aim_hit", hit_logs)
client.set_event_callback("aim_miss", miss_logs)
client.set_event_callback("net_update_start", function()
    Resolver:Animlayer()
    Resolver:Prediction()
end)
client.set_event_callback("shutdown", function()
    save_weights()
end)

