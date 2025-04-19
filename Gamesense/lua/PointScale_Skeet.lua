--Made by dex_t with <3

local Tools = {};

Tools.Velocity2D = function(Player)
    local PVel = {entity.get_prop(Player, "m_vecVelocity")};

    return math.sqrt(PVel[1]^2 + PVel[2]^2);
end

Tools.Distance = function(Player1, Player2)
    local Pos1 = {entity.get_prop(Player1, "m_vecOrigin")};
    local Pos2 = {entity.get_prop(Player2, "m_vecOrigin")};
    
    return math.sqrt((Pos1[1] - Pos2[1])^2 + (Pos1[2] - Pos2[2])^2 + (Pos1[3] - Pos2[3])^2);
end

local PointScale = {};

PointScale.Menu = ui.reference("RAGE", "Aimbot", "Multi-point scale");

local Conditions =  {"Stand", "Run", "Crouch", "Air", "Air Crouch"};
local Distance =    {"Close", "Far"};

PointScale.State =  ui.new_combobox("RAGE", "Aimbot", "Condition", Conditions);
PointScale.Distance =  ui.new_combobox("RAGE", "Aimbot", "Distance", Distance);

PointScale.Sliders = {};

for e, cond in pairs(Conditions) do
    PointScale.Sliders[cond] = {};

    for f, dist in pairs(Distance) do
        PointScale.Sliders[cond][dist] = ui.new_slider("RAGE", "Aimbot", string.format("[%s] [%s] PointScale", cond, dist), 25, 100, 65, true, "%");
    end
end

function Setup_command()
    local Enemy = client.current_threat();
    local Enemy_Flags = 0;

    if Enemy == nil then
        return;
    end

    Enemy_Flags = entity.get_prop(Enemy, "m_fFlags");

    local Enemy_Condition;

    if Enemy_Flags == 261 or Enemy_Flags == 263 then --Crouch
        Enemy_Condition = "Crouch";
    elseif Enemy_Flags == 256 then --Air
        Enemy_Condition = "Air";
    elseif Enemy_Flags == 262 then --Air Crouch
        Enemy_Condition = "Air Crouch";
    else --257 Ground
        if Tools.Velocity2D(Enemy) >= 3 then
            Enemy_Condition = "Run";
        else
            Enemy_Condition = "Stand";
        end
    end

    local Lp = entity.get_local_player();
	
    if Tools.Distance(Lp, Enemy) < 1000 then
        Enemy_Distance_C = "Close";
    else
        Enemy_Distance_C = "Far";
    end
    
    ui.set(PointScale.Menu, ui.get(PointScale.Sliders[Enemy_Condition][Enemy_Distance_C]));
end

function Paint()
    for e, cond in pairs(Conditions) do
        for f, dist in pairs(Distance) do
            if ui.get(PointScale.State) == cond and ui.get(PointScale.Distance) == dist then
                ui.set_visible(PointScale.Sliders[cond][dist], true);
            else
                ui.set_visible(PointScale.Sliders[cond][dist], false);
            end
        end
    end
end

client.set_event_callback("setup_command", function()
    Setup_command();
end);

client.set_event_callback("paint_ui", function()
    Paint();
end);