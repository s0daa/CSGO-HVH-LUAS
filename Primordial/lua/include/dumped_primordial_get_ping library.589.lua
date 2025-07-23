-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local table = {}
table.get_ping = function ()
    return math.floor(1000 * engine.get_latency(e_latency_flows.OUTGOING) +
engine.get_latency(e_latency_flows.INCOMING))

end
return table