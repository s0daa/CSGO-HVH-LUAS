local checkbox = ui.new_checkbox("AA", "Other", "Bernas198 Animation Fix")
local pose_params = {3, 6, 7}
local current_values = {}
local target_values = {}
local smooth_factor = 0.05  -- Quanto menor, mais suave a transição (0.01 a 0.1 recomendado)

-- Inicializa valores aleatórios
for i = 1, #pose_params do
    current_values[i] = math.random()
    target_values[i] = math.random()
end

-- Atualiza os valores-alvo periodicamente para evitar mudanças bruscas
client.set_event_callback("run_command", function()
    if ui.get(checkbox) then
        for i = 1, #pose_params do
            if math.random() < 0.01 then  -- Pequena chance de atualizar o alvo
                target_values[i] = math.random()
            end
        end
    end
end)

client.set_event_callback("pre_render", function()
    if ui.get(checkbox) then
        local local_player = entity.get_local_player()
        if not local_player then return end

        for i, pose_index in ipairs(pose_params) do
            -- Interpolação suave (usando curva senoidal)
            current_values[i] = current_values[i] + (target_values[i] - current_values[i]) * smooth_factor

            entity.set_prop(local_player, "m_flPoseParameter", current_values[i], pose_index)
        end
    end
end)
