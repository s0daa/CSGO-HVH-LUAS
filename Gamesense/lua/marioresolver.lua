local ffi = require('ffi')
local table_new = require('table.new')

-- [x]==========================[ Player-List Control ]==========================[x]
local plylist = {
	reset = {
		ForceBodyYaw = {},
		ForceBodyYawCheckbox = {},
		CorrectionActive = {},
	},
	values = {
		ForceBodyYaw = {},
		ForceBodyYawCheckbox = {},
		CorrectionActive = {},
	},
	ref = {
		selected_player = ui.reference('PLAYERS', 'Players', 'Player list', false)
	}
}

function plylist.GetPlayer()
	return ui.get(plylist['ref'].selected_player)
end

-- Body yaw
function plylist.GetForceBodyYawCheckbox(ent)
	if not ent then
		return
	end
	
	return plist.get(ent, 'Force body yaw')
end

function plylist.SetForceBodyYawCheckbox(ent, val)
	if not ent or plylist['values'].ForceBodyYawCheckbox[ent] == val  then
		return
	end
	plist.set(ent, 'Force body yaw', val)
	plylist['values'].ForceBodyYawCheckbox[ent] = val
end

function plylist.GetBodyYaw(ent)
	if not ent then
		return
	end
	plylist['values'].ForceBodyYaw[ent] = plylist['values'].ForceBodyYaw[ent] or 0
	return plist.get(ent, 'Force body yaw value')
end

function plylist.SetBodyYaw(ent, val)
	if not ent or plylist['values'].ForceBodyYaw[ent] == val then
		return
	end
	plist.set(ent, 'Force body yaw value', val)
	plylist['values'].ForceBodyYaw[ent] = val
end

local function round( num, decimals )
	num = num or 0
	decimals = decimals or 0

	local mult = 10 ^ (decimals)
	return math.floor(num * mult + 0.5) / mult
end

local function clamp( x, min, max )
	x = x or 0
	max = max or 0
	min = min or 0

	return math.min(math.max(min, x), max)
end

local function contains(tbl, val)
	for i=1,#tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function bin_value(value, num_bits)
    local scale_factor = 2 ^ num_bits
    local scaled_value = math.floor(value * scale_factor + 0.5)
    local bits = {}
    for i = num_bits, 1, -1 do
        local bit_value = 2 ^ (i - 1)
        if scaled_value >= bit_value then
            bits[i] = 1
            scaled_value = scaled_value - bit_value
        else
            bits[i] = 0
        end
    end
    return bits
end

local function normalize(value, min, max)
  return (value - min) / (max - min)
end

local function insert_first_index(tbl, value, maxSize)
    if #tbl >= maxSize then
        table.remove(tbl)
    end

    table.insert(tbl, 1, value)
end

local average = function( t )
	t = t or { }

	local sum = 0
	for _,v in pairs(t) do
		sum = sum + v
	end
	return sum / #t
end

local ent_c = {}
ent_c.get_client_entity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

local animation_state_t =
	ffi.typeof('\13\10\9\115\116\114\117\99\116\32\123\13\10\9\9\99\104\97\114\9\117\48\91\32\48\120\49\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\110\105\109\95\117\112\100\97\116\101\95\116\105\109\101\114\59\13\10\9\9\99\104\97\114\9\117\49\91\32\48\120\67\32\93\59\13\10\9\9\102\108\111\97\116\9\115\116\97\114\116\101\100\95\109\111\118\105\110\103\95\116\105\109\101\59\13\10\9\9\102\108\111\97\116\9\108\97\115\116\95\109\111\118\101\95\116\105\109\101\59\13\10\9\9\99\104\97\114\9\117\50\91\32\48\120\49\48\32\93\59\13\10\9\9\102\108\111\97\116\9\108\97\115\116\95\108\98\121\95\116\105\109\101\59\13\10\9\9\99\104\97\114\9\117\51\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\114\117\110\95\97\109\111\117\110\116\59\13\10\9\9\99\104\97\114\9\117\52\91\32\48\120\49\48\32\93\59\13\10\9\9\118\111\105\100\9\42\101\110\116\105\116\121\59\13\10\9\9\95\95\105\110\116\51\50\32\97\99\116\105\118\101\95\119\101\97\112\111\110\59\13\10\9\9\95\95\105\110\116\51\50\32\108\97\115\116\95\97\99\116\105\118\101\95\119\101\97\112\111\110\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\76\97\115\116\67\108\105\101\110\116\83\105\100\101\65\110\105\109\97\116\105\111\110\85\112\100\97\116\101\84\105\109\101\59\13\10\9\9\95\95\105\110\116\51\50\32\109\95\105\76\97\115\116\67\108\105\101\110\116\83\105\100\101\65\110\105\109\97\116\105\111\110\85\112\100\97\116\101\70\114\97\109\101\99\111\117\110\116\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\65\110\105\109\85\112\100\97\116\101\68\101\108\116\97\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\69\121\101\89\97\119\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\80\105\116\99\104\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\71\111\97\108\70\101\101\116\89\97\119\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\67\117\114\114\101\110\116\70\101\101\116\89\97\119\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\67\117\114\114\101\110\116\84\111\114\115\111\89\97\119\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\85\110\107\110\111\119\110\86\101\108\111\99\105\116\121\76\101\97\110\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\76\101\97\110\65\109\111\117\110\116\59\13\10\9\9\99\104\97\114\9\117\53\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\70\101\101\116\67\121\99\108\101\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\70\101\101\116\89\97\119\82\97\116\101\59\13\10\9\9\99\104\97\114\9\117\54\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\68\117\99\107\65\109\111\117\110\116\59\13\10\9\9\102\108\111\97\116\9\109\95\102\76\97\110\100\105\110\103\68\117\99\107\65\100\100\105\116\105\118\101\83\111\109\101\116\104\105\110\103\59\13\10\9\9\99\104\97\114\9\117\55\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\32\9\109\95\118\79\114\105\103\105\110\88\59\32\47\47\48\120\66\48\13\10\9\9\102\108\111\97\116\32\9\109\95\118\79\114\105\103\105\110\89\59\32\47\47\48\120\66\52\13\10\9\9\102\108\111\97\116\32\9\109\95\118\79\114\105\103\105\110\90\59\32\47\47\48\120\66\56\13\10\9\9\102\108\111\97\116\32\9\109\95\118\76\97\115\116\79\114\105\103\105\110\88\59\32\47\47\48\120\66\67\13\10\9\9\102\108\111\97\116\32\9\109\95\118\76\97\115\116\79\114\105\103\105\110\89\59\32\47\47\48\120\67\48\13\10\9\9\102\108\111\97\116\32\9\109\95\118\76\97\115\116\79\114\105\103\105\110\90\59\32\47\47\48\120\67\52\13\10\9\9\102\108\111\97\116\9\109\95\118\86\101\108\111\99\105\116\121\88\59\13\10\9\9\102\108\111\97\116\9\109\95\118\86\101\108\111\99\105\116\121\89\59\13\10\9\9\99\104\97\114\9\117\56\91\32\48\120\49\48\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\85\110\107\110\111\119\110\70\108\111\97\116\49\59\32\47\47\109\111\118\101\95\100\105\114\101\99\116\105\111\110\95\49\13\10\9\9\102\108\111\97\116\9\109\95\102\108\85\110\107\110\111\119\110\70\108\111\97\116\50\59\32\47\47\109\111\118\101\95\100\105\114\101\99\116\105\111\110\95\50\13\10\9\9\99\104\97\114\9\117\57\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\83\112\101\101\100\50\68\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\85\112\86\101\108\111\99\105\116\121\59\32\13\10\9\9\102\108\111\97\116\9\109\95\102\108\83\112\101\101\100\78\111\114\109\97\108\105\122\101\100\59\32\13\10\9\9\102\108\111\97\116\9\109\95\102\108\70\101\101\116\83\112\101\101\100\70\111\114\119\97\114\100\115\79\114\83\105\100\101\87\97\121\115\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\70\101\101\116\83\112\101\101\100\85\110\107\110\111\119\110\70\111\114\119\97\114\100\79\114\83\105\100\101\119\97\121\115\59\32\13\10\9\9\102\108\111\97\116\9\109\95\102\108\84\105\109\101\83\105\110\99\101\83\116\97\114\116\101\100\77\111\118\105\110\103\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\84\105\109\101\83\105\110\99\101\83\116\111\112\112\101\100\77\111\118\105\110\103\59\13\10\9\9\98\111\111\108\9\109\95\98\79\110\71\114\111\117\110\100\59\13\10\9\9\98\111\111\108\9\109\95\98\73\110\72\105\116\71\114\111\117\110\100\65\110\105\109\97\116\105\111\110\59\13\10\9\9\99\104\97\114\9\117\49\48\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\76\97\115\116\79\114\105\103\105\110\90\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\72\101\97\100\72\101\105\103\104\116\79\114\79\102\102\115\101\116\70\114\111\109\72\105\116\116\105\110\103\71\114\111\117\110\100\65\110\105\109\97\116\105\111\110\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\83\116\111\112\84\111\70\117\108\108\82\117\110\110\105\110\103\70\114\97\99\116\105\111\110\59\13\10\9\9\99\104\97\114\9\117\49\49\91\32\48\120\49\52\32\93\59\13\10\9\9\95\95\105\110\116\51\50\32\109\95\102\108\85\110\107\110\111\119\110\70\114\97\99\116\105\111\110\59\13\10\9\9\99\104\97\114\9\117\49\50\91\32\48\120\50\48\32\93\59\13\10\9\9\102\108\111\97\116\9\108\97\115\116\95\97\110\105\109\95\117\112\100\97\116\101\95\116\105\109\101\59\13\10\9\9\102\108\111\97\116\9\109\111\118\105\110\103\95\100\105\114\101\99\116\105\111\110\95\120\59\13\10\9\9\102\108\111\97\116\9\109\111\118\105\110\103\95\100\105\114\101\99\116\105\111\110\95\121\59\13\10\9\9\102\108\111\97\116\9\109\111\118\105\110\103\95\100\105\114\101\99\116\105\111\110\95\122\59\13\10\9\9\99\104\97\114\9\117\49\51\91\32\48\120\52\52\32\93\59\13\10\9\9\95\95\105\110\116\51\50\32\115\116\97\114\116\101\100\95\109\111\118\105\110\103\59\13\10\9\9\99\104\97\114\9\117\49\52\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\108\101\97\110\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\49\53\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\112\111\115\101\115\95\115\112\101\101\100\59\13\10\9\9\99\104\97\114\9\117\49\54\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\108\97\100\100\101\114\95\115\112\101\101\100\59\13\10\9\9\99\104\97\114\9\117\49\55\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\108\97\100\100\101\114\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\49\56\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\115\111\109\101\95\112\111\115\101\59\13\10\9\9\99\104\97\114\9\117\49\57\91\32\48\120\49\52\32\93\59\13\10\9\9\102\108\111\97\116\9\98\111\100\121\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\50\48\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\98\111\100\121\95\112\105\116\99\104\59\13\10\9\9\99\104\97\114\9\117\50\49\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\100\101\97\116\104\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\50\50\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\115\116\97\110\100\59\13\10\9\9\99\104\97\114\9\117\50\51\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\106\117\109\112\95\102\97\108\108\59\13\10\9\9\99\104\97\114\9\117\50\52\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\115\116\97\110\100\95\105\100\108\101\59\13\10\9\9\99\104\97\114\9\117\50\53\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\99\114\111\117\99\104\95\105\100\108\101\59\13\10\9\9\99\104\97\114\9\117\50\54\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\115\116\114\97\102\101\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\50\55\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\115\116\97\110\100\95\119\97\108\107\59\13\10\9\9\99\104\97\114\9\117\50\56\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\115\116\97\110\100\95\114\117\110\59\13\10\9\9\99\104\97\114\9\117\50\57\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\99\114\111\117\99\104\95\119\97\108\107\59\13\10\9\9\99\104\97\114\9\117\51\48\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\109\111\118\101\95\98\108\101\110\100\95\119\97\108\107\59\13\10\9\9\99\104\97\114\9\117\51\49\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\109\111\118\101\95\98\108\101\110\100\95\114\117\110\59\13\10\9\9\99\104\97\114\9\117\51\50\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\109\111\118\101\95\98\108\101\110\100\95\99\114\111\117\99\104\59\13\10\9\9\99\104\97\114\9\117\51\51\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\115\112\101\101\100\59\13\10\9\9\95\95\105\110\116\51\50\32\109\111\118\105\110\103\95\105\110\95\97\110\121\95\100\105\114\101\99\116\105\111\110\59\13\10\9\9\102\108\111\97\116\9\97\99\99\101\108\101\114\97\116\105\111\110\59\13\10\9\9\99\104\97\114\9\117\51\52\91\32\48\120\55\52\32\93\59\13\10\9\9\102\108\111\97\116\9\99\114\111\117\99\104\95\104\101\105\103\104\116\59\13\10\9\9\95\95\105\110\116\51\50\32\105\115\95\102\117\108\108\95\99\114\111\117\99\104\101\100\59\13\10\9\9\99\104\97\114\9\117\51\53\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\118\101\108\111\99\105\116\121\95\115\117\98\116\114\97\99\116\95\120\59\13\10\9\9\102\108\111\97\116\9\118\101\108\111\99\105\116\121\95\115\117\98\116\114\97\99\116\95\121\59\13\10\9\9\102\108\111\97\116\9\118\101\108\111\99\105\116\121\95\115\117\98\116\114\97\99\116\95\122\59\13\10\9\9\102\108\111\97\116\9\115\116\97\110\100\105\110\103\95\104\101\97\100\95\104\101\105\103\104\116\59\13\10\9\125\32\42\42\13\10')

local animation_layer_t =
	ffi.typeof('\13\10\9\115\116\114\117\99\116\32\123\9\9\9\9\9\9\9\9\9\9\99\104\97\114\32\112\97\100\48\91\48\120\49\56\93\59\13\10\9\9\117\105\110\116\51\50\95\116\9\109\95\110\83\101\113\117\101\110\99\101\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\80\114\101\118\67\121\99\108\101\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\87\101\105\103\104\116\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\87\101\105\103\104\116\68\101\108\116\97\82\97\116\101\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\80\108\97\121\98\97\99\107\82\97\116\101\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\67\121\99\108\101\59\13\10\9\9\118\111\105\100\9\9\42\101\110\116\105\116\121\59\9\9\9\9\9\9\99\104\97\114\32\112\97\100\49\91\48\120\52\93\59\13\10\9\125\32\42\42\13\10')

local offsets = {
	animstate = 0x9960,
	animlayer = 0x2990
}

local function animstate(ent)
	local ent_ptr = ffi.cast('void***', ent_c.get_client_entity(ent))
	local animstate_ptr = ffi.cast("char*", ent_ptr) + offsets.animstate
	local entity_animstate = ffi.cast(animation_state_t, animstate_ptr)[0]
	return entity_animstate
end

local function get_animlayer(ent, layer)
	local ent_ptr = ffi.cast('void***', ent_c.get_client_entity(ent or entity.get_local_player()))
	local animlayer_ptr = ffi.cast('char*', ent_ptr) + offsets.animlayer
	local entity_animlayer = ffi.cast(animation_layer_t, animlayer_ptr)[0][layer]
	return entity_animlayer
end

local ACTIVATION_RESPONSE = 1

local NeuralNetwork = {
	transfer = function(x)
		return 1 / (1 + math.exp(-x / ACTIVATION_RESPONSE))
	end, --This is the Transfer function (in this case a sigmoid)

	transfer_inverse = function(y)
		return ACTIVATION_RESPONSE * math.log(y / (1 - y))
	end	--This is the sigmoid's inverse, or the "logit" function
}

function NeuralNetwork.create(_numInputs, _numOutputs, _numHiddenLayers, _neuronsPerLayer, _learningRate)
    _numInputs = _numInputs or 1
    _numOutputs = _numOutputs or 1
    _numHiddenLayers = _numHiddenLayers or math.ceil(_numInputs / 2)
    _neuronsPerLayer = _neuronsPerLayer or math.ceil(_numInputs * .66666 + _numOutputs)
    _learningRate = _learningRate or .5

    local network = setmetatable(
        {
            learningRate = _learningRate
        },
        {__index = NeuralNetwork}
    )

    network[1] = table_new(_numInputs, 0) --Input Layer
    for i = 1, _numInputs do
        network[1][i] = table_new(0, 0)
    end
    for i = 2, _numHiddenLayers + 2 do --plus 2 represents the output layer (also need to skip input layer)
        local neuronsInLayer = _neuronsPerLayer
        if i == _numHiddenLayers + 2 then
            neuronsInLayer = _numOutputs
        end
        network[i] = table_new(neuronsInLayer, 0)
        for j = 1, neuronsInLayer do
            network[i][j] = table_new(_numInputs, 1) -- pre-allocate for weights and bias
            network[i][j].bias = math.random() * 2 - 1
            local numNeuronInputs = #(network[i - 1])
            for k = 1, numNeuronInputs do
                network[i][j][k] = math.random() * 2 - 1 --return random number between -1 and 1
            end
        end
    end
    return network
end

function NeuralNetwork:forewardPropagate(...)
	local arg = {...}
	if #(arg) ~= #(self[1]) and type(arg[1]) ~= "table" then
		error(
			"Neural Network received " ..
				#(arg) .. " input[s] (expected " .. #(self[1]) .. " input[s])",
			2
		)
	elseif type(arg[1]) == "table" and #(arg[1]) ~= #(self[1]) then
		error(
			"Neural Network received " ..
				#(arg[1]) .. " input[s] (expected " .. #(self[1]) .. " input[s])",
			2
		)
	end
	local outputs = {}
	for i = 1, #(self) do
		for j = 1, #(self[i]) do
			if i == 1 then
				if type(arg[1]) == "table" then
					self[i][j].result = arg[1][j]
				else
					self[i][j].result = arg[j]
				end
			else
				self[i][j].result = self[i][j].bias
				for k = 1, #(self[i][j]) do
					self[i][j].result = self[i][j].result + (self[i][j][k] * self[i - 1][k].result)
				end
				self[i][j].result = NeuralNetwork.transfer(self[i][j].result)
				if i == #(self) then
					table.insert(outputs, self[i][j].result)
				end
			end
			self[i][j].active = self[i][j].result > 0.5
		end
	end
	return outputs
end


function NeuralNetwork:backwardPropagate(inputs, desiredOutputs)
	if #(inputs) ~= #(self[1]) then
		error(
			"Neural Network received " ..
				#(inputs) .. " input[s] (expected " .. #(self[1]) .. " input[s])",
			2
		)
	elseif #(desiredOutputs) ~= #(self[#self]) then
		error(
			"Neural Network received " ..
				#(desiredOutputs) ..
					" desired output[s] (expected " .. #(self[#self]) .. " desired output[s])",
			2
		)
	end
	self:forewardPropagate(inputs) --update the internal inputs and outputs
	for i = #self, 2, -1 do --iterate backwards (nothing to calculate for input layer)
		local tempResults = {}
		for j = 1, #self[i] do
			if i == #self then --special calculations for output layer
				self[i][j].delta = (desiredOutputs[j] - self[i][j].result) * self[i][j].result * (1 - self[i][j].result)
			else
				local weightDelta = 0
				for k = 1, #self[i + 1] do
					weightDelta = weightDelta + self[i + 1][k][j] * self[i + 1][k].delta
				end
				self[i][j].delta = self[i][j].result * (1 - self[i][j].result) * weightDelta
			end
		end
	end
	for i = 2, #self do
		for j = 1, #self[i] do
			self[i][j].bias = self[i][j].delta * self.learningRate
			for k = 1, #self[i][j] do
				self[i][j][k] = self[i][j][k] + self[i][j].delta * self.learningRate * self[i - 1][k].result
			end
		end
	end
end

local scr_w, scr_h = client.screen_size()
function NeuralNetwork:render()
	local neuronRadius = 3
	local neuronSpacing = 1
	local start_pos = (scr_w - ((scr_w/2) + ((scr_w/2)/2)))
	local layerSpacing = (scr_w - (scr_w/2 - start_pos)*2 - neuronRadius*4)/2
	local neuronColor = {r = 122, g = 122, b = 122, a = 60}
	local connectionColor = {r = 168, g = 229, b = 255, a = 50}
	local activeNeuronColor = {r = 255, g = 179, b = 38, a = 80}

	for layerIndex, layer in ipairs(self) do
		local layerX = (layerIndex - 1) * (neuronRadius * 2 + layerSpacing) + start_pos
		for neuronIndex, neuron in ipairs(layer) do
			local neuronY = (neuronIndex - 1) * (neuronRadius * 2 + neuronSpacing)
			local color = neuron.active and activeNeuronColor or neuronColor
			renderer.circle(layerX+neuronRadius, neuronY+neuronRadius, color.r, color.g, color.b, color.a, neuronRadius, 0, 1)
			if layerIndex > 1 then
				local previousLayer = self[layerIndex - 1]
				for previousNeuronIndex, previousNeuron in ipairs(previousLayer) do
					local previousNeuronY = (previousNeuronIndex - 1) * (neuronRadius * 2 + neuronSpacing)
					renderer.line(layerX, neuronY+neuronRadius, layerX - layerSpacing + neuronRadius, previousNeuronY, connectionColor.r, connectionColor.g, connectionColor.b, (neuron.active and previousNeuron.active) and connectionColor.a or 0)
				end
			end
		end
	end
end

function NeuralNetwork:train( trainingSet, attempts)
	while attempts > 0 do
		for i = 1,#trainingSet do
			self:backwardPropagate(trainingSet[i].input,trainingSet[i].output)
		end
		attempts = attempts - 1
	end
end

function NeuralNetwork:save()
	local data =
		"|INFO|FF BP NN|I|" ..
		tostring(#(self[1])) ..
			"|O|" ..
				tostring(#(self[#self])) ..
					"|HL|" ..
						tostring(#self - 2) ..
							"|NHL|" .. tostring(#(self[2])) .. "|LR|" .. tostring(self.learningRate) .. "|BW|"
	for i = 2, #self do -- nothing to save for input layer
		for j = 1, #self[i] do
			local neuronData = tostring(self[i][j].bias) .. "{"
			for k = 1, #(self[i][j]) do
				neuronData = neuronData .. tostring(self[i][j][k])
				neuronData = neuronData .. ","
			end
			data = data .. neuronData .. "}"
		end
	end
	data = data .. "|END|"
	return data
end

function NeuralNetwork.load(data)
	local dataPos = string.find(data, "|") + 1
	local currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
	local dataPos = string.find(data, "|", dataPos) + 1
	local _inputs, _outputs, _hiddenLayers, _neuronsPerLayer, _learningRate
	local biasWeights = {}
	local errorExit = false
	while currentChunk ~= "END" and not errorExit do
		if currentChuck == "INFO" then
			currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
			dataPos = string.find(data, "|", dataPos) + 1
			if currentChunk ~= "FF BP NN" then
				errorExit = true
			end
		elseif currentChunk == "I" then
			currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
			dataPos = string.find(data, "|", dataPos) + 1
			_inputs = tonumber(currentChunk)
		elseif currentChunk == "O" then
			currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
			dataPos = string.find(data, "|", dataPos) + 1
			_outputs = tonumber(currentChunk)
		elseif currentChunk == "HL" then
			currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
			dataPos = string.find(data, "|", dataPos) + 1
			_hiddenLayers = tonumber(currentChunk)
		elseif currentChunk == "NHL" then
			currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
			dataPos = string.find(data, "|", dataPos) + 1
			_neuronsPerLayer = tonumber(currentChunk)
		elseif currentChunk == "LR" then
			currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
			dataPos = string.find(data, "|", dataPos) + 1
			_learningRate = tonumber(currentChunk)
		elseif currentChunk == "BW" then
			currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
			dataPos = string.find(data, "|", dataPos) + 1
			local subPos = 1
			local subChunk
			for i = 1, _hiddenLayers + 1 do
				biasWeights[i] = {}
				local neuronsInLayer = _neuronsPerLayer
				if i == _hiddenLayers + 1 then
					neuronsInLayer = _outputs
				end
				for j = 1, neuronsInLayer do
					biasWeights[i][j] = {}
					biasWeights[i][j].bias =
						tonumber(string.sub(currentChunk, subPos, string.find(currentChunk, "{", subPos) - 1))
					subPos = string.find(currentChunk, "{", subPos) + 1
					subChunk = string.sub(currentChunk, subPos, string.find(currentChunk, ",", subPos) - 1)
					local maxPos = string.find(currentChunk, "}", subPos)
					while subPos < maxPos do
						table.insert(biasWeights[i][j], tonumber(subChunk))
						subPos = string.find(currentChunk, ",", subPos) + 1
						if string.find(currentChunk, ",", subPos) ~= nil then
							subChunk = string.sub(currentChunk, subPos, string.find(currentChunk, ",", subPos) - 1)
						end
					end
					subPos = maxPos + 1
				end
			end
		end
		currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
		dataPos = string.find(data, "|", dataPos) + 1
	end

	if errorExit then
		error("Failed to load Neural Network:" .. currentChunk, 2)
	end

	local network = setmetatable(
		{
			learningRate = _learningRate
		},
		{__index = NeuralNetwork}
	)
		
	network[1] = {} --Input Layer
	for i = 1, _inputs do
		network[1][i] = {}
	end
	for i = 2, _hiddenLayers + 2 do --plus 2 represents the output layer (also need to skip input layer)
		network[i] = {}
		local neuronsInLayer = _neuronsPerLayer
		if i == _hiddenLayers + 2 then
			neuronsInLayer = _outputs
		end
		for j = 1, neuronsInLayer do
			network[i][j] = {bias = biasWeights[i - 1][j].bias}
			local numNeuronInputs = #(network[i - 1])
			for k = 1, numNeuronInputs do
				network[i][j][k] = biasWeights[i - 1][j][k]
			end
		end
	end
	return network
end

-- Function to create UI elements and set visibility
local function create_ui_element(element_type, category, name, args, visible, callback)
    local element
    if element_type == 'slider' then
        element = ui.new_slider(category, 'A', name, args[1], args[2], args[3], true, "", args[4])
    elseif element_type == 'multiselect' then
        element = ui.new_multiselect(category, 'A', name, args)
    elseif element_type == 'button' then
        element = ui.new_button(category, 'A', name, args or function() end)
    end
    ui.set_visible(element, visible)
	
	if callback and element_type ~= 'button' then
		ui.set_callback(element, callback)
	end

    return element
end

-- Configuration variables
local mul, binary_size = 1000000000, 20  -- Multiplier and size of binary representation
local nn_preset = '|INFO|FF BP NN|I|40|O|1|HL|1|NHL|10|LR|0.3|BW|-1.1559066392366e-05{-1.1202450064138,-0.43692358428945,-0.13930987099988,1.2473693747317,-1.0512952920563,1.3270403255733,-1.3048390365862,0.67144977762124,0.22895362182248,-0.80409868646125,0.80970370419299,-0.094876011124505,1.8085297300312,-3.1213051697127,0.15564586269487,1.243941161686,-0.63451864091975,0.85274078529101,1.2094977572229,0.62863360591113,-0.65126689180398,-0.59910446978325,-0.27530302959635,-0.37900970996814,-0.45176552529037,0.55370533700818,0.64138597420234,0.55680960465419,-0.61526474930497,0.3636652929368,-0.065175113965139,-0.36903881731361,0.12405837818835,-0.73977745618948,0.63540725046327,-0.45414746029774,0.79157121985721,-0.42317748048187,0.079063967276199,0.94263076966404,}3.1873687881385e-07{-0.33085972681749,1.3974765045622,-0.53805929633813,-0.67028441463719,0.9546600346727,-0.20504330455771,0.14603469737588,-0.22584991835587,-0.59708982950384,-0.096585443153326,-0.40914869100385,0.15252807361841,0.76983088009555,0.1135895273262,-0.046635440565021,0.052936898188129,0.43810347271126,0.7730153833329,0.66231510990403,0.58338534121945,0.86213212067021,0.87378351704409,-0.91200616034745,0.96259979650566,0.48645308856345,-0.62811218755657,0.37356359696407,0.85840784699586,0.53809980261285,0.67041507564095,-0.28260659218288,-0.83469318664078,-0.71786782846342,0.20177599197934,0.5580614689448,-0.14722750093401,-0.8674737129836,-0.12700793895558,0.18537378239585,0.64549671395507,}4.2982839371136e-06{-0.25445981857133,0.13249673996283,-0.2718035127553,-0.72430954461389,1.4232117247034,-0.33952965981642,1.6825855658027,0.4430270099209,0.15716956679741,1.1364623417016,-1.2811299615557,-2.467200066115,-0.36174012131967,2.7037878931814,-0.34114087452533,-1.7333547565663,-1.0167292273294,-0.80970388354612,0.1237717895204,0.36641949687082,-0.11871201536506,-0.8181383753111,-0.25342722612542,0.38346749694153,0.33325877812144,-0.26414654291822,0.14819168394517,-0.077031835047591,-0.16050719194423,0.21618455873618,-0.54693088064852,-0.23786000247078,-0.59803675764093,1.0923008303097,0.17366075046142,0.54290923518083,0.60140644190717,0.05974144182409,-0.10139665145658,-0.15275546046583,}5.1234789449184e-08{-0.18017558513543,-0.18146265689724,0.19828598581944,0.44190756360128,-0.22332667322822,0.30169325630054,0.97082021620136,-0.23322485853026,-0.65912975643021,1.3692117676815,-0.72319483106828,-1.0883591535332,-0.46589031854902,-0.073792583922551,0.36310819165966,-0.0053283265286844,0.47961491373351,1.0974451087232,-0.70320902143542,-0.087953350778685,1.0191600187128,0.17360115911924,0.069900569787577,-0.16813379753614,0.58380508079408,0.059608837989604,-0.73024469728429,0.13274871928125,0.11332417366227,-0.31200221713205,0.23947432231531,1.0454803228932,0.8758172416385,-0.46659133456749,-0.01452242480419,0.48269143866338,-0.1505119234022,-0.53428273563778,1.1124781201795,0.7158579485146,}-1.5923623174481e-07{0.85339968189486,-0.0031680515790833,-0.39202082971167,-0.01225315528781,-0.57344056356219,1.2631862215949,0.047128925306942,-1.4902526401776,-0.090282461185964,0.0051083609777073,0.31153197386897,0.17016429041934,1.659032504245,-0.73128928650677,0.4670939328216,0.028794360062452,-0.835364828446,1.0444326143459,0.32932243316448,0.19423058285795,0.064800248455427,0.44604158652933,-0.88846000046558,0.26087480381279,-0.31110295966076,-0.29340717912116,0.3893207825555,-0.12011290761793,0.74345863790375,0.91991374081139,0.58451763390618,1.0669202255176,0.9151380516102,-0.48160558880747,0.92929454785814,0.28369332396192,0.51683013032091,-0.90813461356797,0.11724769174449,-0.95568308718194,}-2.6915435839416e-06{0.15231248617089,-0.53598711108745,-1.0728578555855,0.36259922426732,0.031027769372601,0.26773876558409,0.64368096063365,-0.25774347079668,-0.54249611885042,-0.37569923896152,1.3102568839229,1.3606470022779,1.315893134815,-1.3041749157242,-0.11526832004411,0.92184110918755,-0.093661224545601,-0.88577712061228,0.63818458911472,-0.26442642654138,-1.1176712678031,0.25360377550678,0.3515439997362,-0.69789425814896,-0.4687938342845,0.82667253233937,0.467816069347,0.44591920582718,0.05545307746697,-0.60233019250446,-0.71215641270195,-0.53751447248309,-0.45065874409576,0.42354298216433,-0.0014788537422028,-0.73425343246317,0.47007202514344,-0.46357977355352,-1.2892936180133,-0.048225560467511,}-2.2203811792948e-07{-0.35923888252987,-0.20438667385787,-0.19124147250491,0.76882231523259,0.60367368248321,-1.0389538006775,-0.61313909750184,0.40870492709999,-0.72515795426014,-1.0689391477852,0.87347072473302,0.91819843344018,-0.20062971447343,0.40036925489807,-0.041060377554657,-0.49109735768139,-0.66679007149362,-0.36921711689963,0.22104603934927,-0.16034076612188,0.14148837206228,0.30385765762427,0.77164356236879,0.84512822072436,0.45189599713861,-0.32517192253332,0.97068735065427,0.93647534203954,0.88377609020537,-0.70700992716569,0.93760202670951,0.059062141340008,0.54097694578813,-0.53362426864334,-0.33198341878765,-0.84667381438854,1.095885343958,0.66440180345932,-0.53341022968168,-0.31280200102565,}-7.7144999220949e-08{0.2099088837233,0.41124969823218,0.26237623960241,0.010632764815006,-0.69550129162016,1.0309324303167,-2.3945268806069,-1.0900830278076,-0.97074897000463,-0.64712273581935,-0.14397363140143,-0.62111675762407,-0.50609306043648,-1.1836989201552,-0.27635932911943,-0.021133962558542,-0.71273397289237,-0.76600974074245,-0.25077719867282,-0.81734393863832,0.47239605660163,-0.66353076564059,0.86867198848571,-0.79615191780073,-0.0022895055875506,0.64980972601548,-0.16107170872416,0.80976610335076,0.94472563914824,-0.53645065120444,0.030698189248155,0.34301072287199,-0.3691108833124,-0.12511525153045,-1.1246609938741,-0.41765170598958,-0.30162418790371,-0.28050202302667,0.84343770289887,0.34903091158625,}8.0352707438157e-08{-0.51405999934921,0.0044459209144511,0.30461398228033,0.95000878369673,0.16155907388394,0.42705049012585,0.65182535858805,0.65344203842455,0.27293328175436,1.1721316374074,-0.034035069744857,-0.43404730540217,-0.68429164676573,-0.32332730912654,0.56993065489951,-0.014621209625948,-0.11099663675097,1.3579581445072,-0.27863263894567,-0.55714914897038,-0.60478575969188,-0.49545399672518,0.71208007180686,0.48439443134997,0.12846042466121,0.55861815908385,1.0799294894551,0.12195062728068,-0.90166846045791,-0.51862481544792,-0.24235415755116,-0.19301095955542,1.1633646789943,0.84032850506353,-0.57698419406506,0.686434184688,0.37527363998036,0.010136967906187,-0.39289912738176,-0.52391641291929,}3.9142267087638e-06{-0.42098484784357,-0.25546825964372,-0.76476298796809,0.8142147066408,1.5127730763427,-0.75631497465614,0.28598238176559,-0.33012846499604,-0.91616485085432,0.81551319574826,0.53773987298677,0.26636333938819,-1.0291460002793,1.1510905341627,0.66077086811555,-1.0384144522199,-0.32567602055811,1.0394917903945,0.77196468624017,0.50600831732912,-0.26120500875638,-0.95893895895136,-0.064147992016425,0.072218774618524,-1.1388010084736,-0.73853337106534,-0.24610589258136,0.02514605332215,0.54960616687421,0.75275549013141,0.67453346700391,-0.60164983523389,0.50611628328965,-0.58695247773995,0.54917372627756,-0.32598410448479,0.57677346537166,0.77028748812782,-0.72799863028805,0.51131434164369,}-9.345162504613e-06{5.293159010446,-0.89468979823207,-5.2575120035085,-1.1118852011227,1.61133844062,3.2848256677548,0.1746561427601,3.4871115367329,-0.44974464033245,-2.588796188171,}|END|'

-- Initialize a neural network with the given topology
local nn_network = NeuralNetwork.create(120, 1, 1, 10, 0.3)


-- Create UI elements
local options_multibox = create_ui_element('multiselect', 'LUA', '\a0078FFFFMario\'s\aFFFFFFFF NN\aCACACAFF Resolver\a0078FFFF', {'Enable', 'Use local player', 'Visualisation', 'Debug logs'}, true)
local attempts_slider = create_ui_element('slider', 'LUA', 'Attempts', {1, 1000, 10, 1}, true)
local repeat_cycle = create_ui_element('slider', 'LUA', 'Repeat cycle', {1, 10, 10, 1}, true)
local repeat_speed = create_ui_element('slider', 'LUA', 'Repeat speed', {1, 10, 1, 0.1}, true)

local buttons = {
    'Auto Train NN', 'Stop Auto Train NN', 'Train Left NN', 'Stop Train Left NN',
    'Train Right NN', 'Stop Train Right NN', '\a0F8100FFRun NN', 'Stop NN',
	'Save NN', 'Load NN', 'Load Pre-Trained NN', 'Reset NN'
}

local ui_callbacks = {
	save_nn = function()
		print("Saving Neural Network as 'neuralNet.txt'...")
		writefile("neuralNet.txt", nn_network:save())
	end,
	load_nn = function()
		print("Loading Neural Network State...")
		nn_network = NeuralNetwork.load(readfile("neuralNet.txt"))
	end,
	['load_pre-trained_nn'] = function()
		print("Loading Neural Network pre-trained...")
		nn_network = NeuralNetwork.load(nn_preset)
	end,
	reset_nn = function()
		print("Resetting Neural Network...")
		nn_network = NeuralNetwork.create(40, 1, 1, 10, 0.3)
	end
}

local button_elements = {}
for _, button_name in pairs(buttons) do
	format_name = button_name:lower()
	format_name = format_name:gsub(" ", "_")
	format_name = format_name:gsub("\a0f8100ff", "")

    button_elements[format_name] = create_ui_element('button', 'LUA', button_name, ui_callbacks[format_name], true)
end

local last_log
local function log(...)
    local debug_logs = contains(ui.get(options_multibox), 'Debug logs')
    if not debug_logs or last_log == ... then return end
	last_log = ...
    print(...)
end

-- Render the neural network if the corresponding checkbox is checked in the UI
local function render_nn()
	local visualize = contains(ui.get(options_multibox), 'Visualisation')
	if visualize then
		nn_network:render()
	end
end

-- Create tables for storing animation layer and velocity records for entities
local animlayer_rec_t = {}
local animlayer_average_t = {}
local velocity_rec_t = {}

-- Function to retrieve animation layer record of an entity
local function get_animlayer_rec(ent)
	animlayer_rec_t[ent] = animlayer_rec_t[ent] or 0
	return animlayer_rec_t[ent]
end

-- Function to retrieve velocity record of an entity
local function get_velocity_rec(ent)
	velocity_rec_t[ent] = velocity_rec_t[ent] or 0
	return velocity_rec_t[ent]
end

-- Handle entities - called at the start of every network update
local function handle_entities()
	local lp = entity.get_local_player()
	local use_lp = contains(ui.get(options_multibox), 'Use local player')
	
	-- Get a list of enemies
	local enemies = use_lp and {lp} or entity.get_players(true)

	-- Iterate over each enemy
	for i=1, #enemies do
		local ent = enemies[i] or lp
		-- Skip dead players
		if not entity.is_alive(ent) or not entity.is_alive(lp) then
			return
		end

		-- Get animation layer and velocity properties of the enemy
		local anim_layer_6 = get_animlayer(ent, 6)
		local velocity = { entity.get_prop(ent, "m_vecVelocity") }

		-- Normalize and round velocity
		local m_flVelocity2D = normalize(math.sqrt(velocity[1]^2+velocity[2]^2), 0, 260)

		-- Calculate playback rate and round it
		local m_flPlaybackRate = anim_layer_6.m_flPlaybackRate*mul
		--m_flPlaybackRate = round(tonumber(tostring(m_flPlaybackRate):sub(5,#tostring(m_flPlaybackRate))), 6)
		if m_flPlaybackRate == nil then return end
		animlayer_average_t[ent] = animlayer_average_t[ent] or {m_flPlaybackRate}
		insert_first_index(animlayer_average_t[ent], m_flPlaybackRate, 18)
		local pbr = normalize(average(animlayer_average_t[ent]), 0, 21973819.471897)
		--log(m_flVelocity2D..' | '..pbr.. ' | '..table.concat(animlayer_average_t[ent], ', '))
		-- Record the calculated properties for the enemy
		animlayer_rec_t[ent] = pbr
		velocity_rec_t[ent] = m_flVelocity2D	
	end
end

-- Set up event callback to handle entities at the start of each network update
client.set_event_callback('net_update_start', handle_entities)

-- Initialize training and running states
local train_l, train_r, auto_train, run = {running = false, count = 0}, {running = false, count = 0}, {running = false, count = 0}, {running = false, count = 0}

-- Function to run the neural network
local function run_nn()
	if not run.running then return end  -- Exit if not in running state
	log("Running Neural Network...")
	
	local use_lp = contains(ui.get(options_multibox), 'Use local player')
	
	-- Get a list of enemies
	local enemies = use_lp and {entity.get_local_player()} or entity.get_players(true)

	-- Iterate over each enemy
	for i=1, #enemies do
		local ent = enemies[i]

		-- Retrieve the recorded properties for the enemy
		local m_flVelocity2D = get_velocity_rec(ent)
		local m_flPlaybackRate = get_animlayer_rec(ent)
		if m_flPlaybackRate == nil then return end
		-- Convert the properties to binary representation
		local bin_pbr = bin_value(m_flPlaybackRate, binary_size)
		local bin_vel = bin_value(m_flVelocity2D, binary_size)

		-- Combine the binary representations into a single table
		local t = bin_pbr
		for i=1, #bin_vel do
			table.insert(t, bin_vel[i])
		end
		--local t = {m_flPlaybackRate, m_flVelocity2D}
		-- Run the forward propagation of the neural network on the combined input
		local forward = nn_network:forewardPropagate( t )[1]

		-- Apply the neural network's decision to the enemy
		plylist.SetForceBodyYawCheckbox(ent, true)
		plylist.SetBodyYaw(ent, (forward < 0.5 and -60 or 60))

		-- Print the results for debugging
		log(table.concat(t, '') .. "\nm_flPlaybackRate: " .. m_flPlaybackRate .." | side: " .. (forward < 0.5 and 'left' or 'right').. ' | forewardPropagate: ' ..forward)
	end

	-- Schedule the next run of the neural network
	client.delay_call(ui.get(repeat_speed)/10, run_nn)
end

local body_yaw, body_yaw_val = ui.reference('AA', 'Anti-Aimbot angles', 'Body yaw')
local roll_val = ui.reference('AA', 'Anti-Aimbot angles', 'Roll')
local force_train = 'left'

-- Function to train the neural network to move to the left
local function auto_train_f()
	local rep_cycle = ui.get(repeat_cycle)
	if not auto_train.running or (auto_train.count >= rep_cycle and rep_cycle < 10) then
		auto_train = {running = false, count = 0}
		ui.set_visible(button_elements.stop_train_left_nn, false)
		ui.set_visible(button_elements.train_left_nn, true)
		return
	end
	
	local body_yaw = ui.get(body_yaw_val)
	--ui.set(body_yaw_val, (force_train == 'left' and ui.get(body_yaw_val) < 0) and math.abs(ui.get(body_yaw_val)) or ((force_train == 'right' and ui.get(body_yaw_val) > 0) and -math.abs(ui.get(body_yaw_val)) or  ui.get(body_yaw_val)))
	
	local roll = ui.get(roll_val)
	ui.set(roll_val, (force_train == 'left' and ui.get(roll_val) < 0) and math.abs(ui.get(roll_val)) or ((force_train == 'right' and ui.get(roll_val) > 0) and -math.abs(ui.get(roll_val)) or  ui.get(roll_val)))
	
	local t_side = roll > 0 and 0 or 1
	

	log("Auto training neural network:")

	local lp = entity.get_local_player()
	local use_lp = contains(ui.get(options_multibox), 'Use local player')
	
	-- Get a list of enemies
	local enemies = use_lp and {lp} or entity.get_players(true)

	for i=1, #enemies do
		local ent = enemies[i]
		local m_flVelocity2D = get_velocity_rec(ent)
		local m_flPlaybackRate = get_animlayer_rec(ent)
		if m_flPlaybackRate == nil then return client.delay_call(ui.get(repeat_speed)/10, train_left) end
		local bin_pbr = bin_value(m_flPlaybackRate, binary_size)
		local bin_vel = bin_value(m_flVelocity2D, binary_size)
		
		local t = bin_pbr
		for i=1, #bin_vel do
			table.insert(t, bin_vel[i])
		end

		local attempts = ui.get(attempts_slider) -- number of times to do backpropagation
		for i = 1, attempts do
			nn_network:backwardPropagate(t, {t_side}) -- left
		end
		
		local forward = nn_network:forewardPropagate( t )[1]
		local forward_side = (forward < 0.5 and 'left' or 'right')
		force_train = forward_side == force_train and (force_train == 'left' and 'right' or 'left') or force_train

		log(table.concat(t, '') .. "\nm_flPlaybackRate: " .. m_flPlaybackRate .." | side: " .. forward_side .. ' | forewardPropagate: ' ..forward)
	end
	auto_train.count = auto_train.count == 10 and 0 or auto_train.count + 1
	client.delay_call(ui.get(repeat_speed)/10, auto_train_f)
end

-- Function to train the neural network to move to the left
local function train_left()
	local rep_cycle = ui.get(repeat_cycle)
	if not train_l.running or (train_l.count >= rep_cycle and rep_cycle < 10) then
		train_l = {running = false, count = 0}
		ui.set_visible(button_elements.stop_train_left_nn, false)
		ui.set_visible(button_elements.train_left_nn, true)
		return
	end

	log("Training the left neural network:")

	local lp = entity.get_local_player()
	local use_lp = contains(ui.get(options_multibox), 'Use local player')
	
	-- Get a list of enemies
	local enemies = use_lp and {lp} or entity.get_players(true)

	for i=1, #enemies do
		local ent = enemies[i]
		local m_flVelocity2D = get_velocity_rec(ent)
		local m_flPlaybackRate = get_animlayer_rec(ent)
		if m_flPlaybackRate == nil then return client.delay_call(ui.get(repeat_speed)/10, train_left) end
		local bin_pbr = bin_value(m_flPlaybackRate, binary_size)
		local bin_vel = bin_value(m_flVelocity2D, binary_size)
		
		local t = bin_pbr
		for i=1, #bin_vel do
			table.insert(t, bin_vel[i])
		end
		--local t = {m_flPlaybackRate, m_flVelocity2D}
		local attempts = ui.get(attempts_slider) -- number of times to do backpropagation
		for i = 1, attempts do
			nn_network:backwardPropagate(t, {0})
		end
		
		local forward = nn_network:forewardPropagate( t )[1]
		log(table.concat(t, '') .. "\nm_flPlaybackRate: " .. m_flPlaybackRate .." | side: " .. (forward < 0.5 and 'left' or 'right').. ' | forewardPropagate: ' ..forward)
	end
	train_l.count = train_l.count == 10 and 0 or train_l.count + 1
	client.delay_call(ui.get(repeat_speed)/10, train_left)
end

-- Function to train the neural network to move to the right
local function train_right()
	local rep_cycle = ui.get(repeat_cycle)
	if not train_r.running or (train_r.count >= rep_cycle and rep_cycle < 10) then
		train_r = {running = false, count = 0}
		ui.set_visible(button_elements.stop_train_right_nn, false)
		ui.set_visible(button_elements.train_right_nn, true)
		return
	end
	log("Training the right neural network:")
	--local ent = client.current_threat()
	local enemies = entity.get_players(true)

	for i=1, #enemies do
		local ent = enemies[i]
		local m_flVelocity2D = get_velocity_rec(ent)
		local m_flPlaybackRate = get_animlayer_rec(ent)
		if m_flPlaybackRate == nil then return client.delay_call(ui.get(repeat_speed)/10, train_right) end
		local bin_pbr = bin_value(m_flPlaybackRate, binary_size)
		local bin_vel = bin_value(m_flVelocity2D, binary_size)
		
		local t = bin_pbr
		for i=1, #bin_vel do
			table.insert(t, bin_vel[i])
		end
		--local t = {m_flPlaybackRate, m_flVelocity2D}
		local attempts = ui.get(attempts_slider) -- number of times to do backpropagation
		for i = 1, attempts do
			nn_network:backwardPropagate(t, {1})
		end
		
		local forward = nn_network:forewardPropagate( t )[1]
		log(table.concat(t, '') .. "\nm_flPlaybackRate: " .. m_flPlaybackRate .." | side: " .. (forward < 0.5 and 'left' or 'right').. ' | forewardPropagate: ' ..forward)
	end
	train_r.count = train_r.count == 10 and 0 or train_r.count + 1
	client.delay_call(ui.get(repeat_speed)/10, train_right)
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

local tmp_t = {}
local function aim_fire(e)
	local train_on = contains(ui.get(options_multibox), 'Train on hit/miss')
	if not train_on then return end
	local m_flVelocity2D = get_velocity_rec(e.target)
	local m_flPlaybackRate = get_animlayer_rec(e.target)
	if m_flPlaybackRate == nil then return end
	local bin_pbr = bin_value(m_flPlaybackRate, binary_size)
	local bin_vel = bin_value(m_flVelocity2D, binary_size)
	
	tmp_t = bin_pbr
	for i=1, #bin_vel do
		table.insert(tmp_t, bin_vel[i])
	end
	--local t = {m_flPlaybackRate, m_flVelocity2D}

end
client.set_event_callback('aim_fire', aim_fire)

local function aim_hit(e)
	local train_on = contains(ui.get(options_multibox), 'Train on hit/miss')
	if not train_on then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
	if not entity.is_enemy(e.target) then return end
	local body_yaw = plylist.GetBodyYaw(e.target)
	for i = 1, (group == 'head' and 1000 or 100) do
		nn_network:backwardPropagate(tmp_t, {(body_yaw < 0 and 0 or 1)})
	end
	local forward = nn_network:forewardPropagate( tmp_t )[1]
	log(table.concat(tmp_t, '') .." | side: " .. (forward < 0.5 and 'left' or 'right').. ' | forewardPropagate: ' ..forward)
end
client.set_event_callback('aim_hit', aim_hit)

local function aim_miss(e)
	local train_on = contains(ui.get(options_multibox), 'Train on hit/miss')
	if not train_on or e.reason ~= '?' then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
	if not entity.is_enemy(e.target) then return end
	local body_yaw = plylist.GetBodyYaw(e.target)
	for i = 1, (group == 'head' and 1000 or 100) do
		nn_network:backwardPropagate(tmp_t, {(body_yaw < 0 and 1 or 0)})
	end
	local forward = nn_network:forewardPropagate( tmp_t )[1]
	log(table.concat(tmp_t, '') .." | side: " .. (forward < 0.5 and 'left' or 'right').. ' | forewardPropagate: ' ..forward)
end
client.set_event_callback('aim_miss', aim_miss)

ui.set_callback(button_elements.auto_train_nn, function(obj)
	auto_train.running = true
	auto_train_f()
	ui.set_visible(obj, false)
	ui.set_visible(button_elements.stop_auto_train_nn, true)
	if not run.running then
		client.set_event_callback('paint_ui', render_nn)
	end
end)

ui.set_callback(button_elements.stop_auto_train_nn, function(obj)
	auto_train.running = false
	ui.set_visible(obj, false)
	ui.set_visible(button_elements.auto_train_nn, true)
	if not run.running then
		client.unset_event_callback('paint_ui', render_nn)
	end
end)

ui.set_callback(button_elements.train_right_nn, function(obj)
	train_r.running = true
	train_right()
	ui.set_visible(obj, false)
	ui.set_visible(button_elements.stop_train_right_nn, true)
	if not run.running then
		client.set_event_callback('paint_ui', render_nn)
	end
end)

ui.set_callback(button_elements.stop_train_right_nn, function(obj)
	train_r.running = false
	if not run.running then
		client.unset_event_callback('paint_ui', render_nn)
	end
end)

ui.set_callback(button_elements.train_left_nn, function(obj)
	train_l.running = true
	train_left()
	ui.set_visible(obj, false)
	ui.set_visible(button_elements.stop_train_left_nn, true)
	if not run.running then
		client.set_event_callback('paint_ui', render_nn)
	end
end)

ui.set_callback(button_elements.stop_train_left_nn, function(obj)
	train_l.running = false
	if not run.running then
		client.unset_event_callback('paint_ui', render_nn)
	end
end)

ui.set_callback(button_elements.run_nn, function(obj)
	run.running = true
	run_nn()
	ui.set_visible(obj, false)
	ui.set_visible(button_elements.stop_nn, true)
	if not train_l.running and not train_r.running then
		client.set_event_callback('paint_ui', render_nn)
	end
end)

ui.set_callback(button_elements.stop_nn, function(obj)
	run.running = false
	ui.set_visible(obj, false)
	ui.set_visible(button_elements.run_nn, true)
	if not train_l.running and not train_r.running then
		client.unset_event_callback('paint_ui', render_nn)
	end
end)

ui.set_callback(options_multibox, function(obj)
	local enabled = contains(ui.get(options_multibox), 'Enable')
	if enabled and not run.running then
		run.running = true
		run_nn()
		if not train_l.running and not train_r.running then
			client.set_event_callback('paint_ui', render_nn)
		end
	elseif run.running and not enabled then
		run.running = false
		if not train_l.running and not train_r.running then
			client.unset_event_callback('paint_ui', render_nn)
		end
	end
end)


-- Load pre-trained neural network if save file does not exist
--[[local save_file = readfile('neuralNet.txt')
if save_file then
	nn_network = NeuralNetwork.load(save_file)
else
	nn_network = NeuralNetwork.load(nn_preset)
end]]
nn_network = NeuralNetwork.load(nn_preset)