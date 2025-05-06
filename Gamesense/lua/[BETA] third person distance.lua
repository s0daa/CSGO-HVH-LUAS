client.log("Dev: bernas198")

-- local variables for API
local ui_get, ui_set, ui_new_slider, client_set_cvar, entity_get_local_player, entity_is_alive = 
    ui.get, ui.set, ui.new_slider, client.set_cvar, entity.get_local_player, entity.is_alive

-- Criar um slider para ajustar a distância da terceira pessoa
local thirdperson_distance = ui_new_slider("VISUALS", "Effects", "Thirdperson Distance", 50, 300, 150)

-- Função para atualizar a distância da terceira pessoa
local function update_thirdperson()
    local local_player = entity_get_local_player() -- Pega o jogador local
    if local_player and entity_is_alive(local_player) then
        local distance = ui_get(thirdperson_distance) -- Obtém o valor do slider
        client_set_cvar("cam_idealdist", distance)   -- Define a nova distância
    end
end

-- Chamar a função sempre que um novo frame for renderizado
client.set_event_callback("paint", update_thirdperson)
