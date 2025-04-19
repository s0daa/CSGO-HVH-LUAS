local url = "https://discord.gg/CAr3AEHHGZ"

-- Adiciona a checkbox "Enable resolver" acima do botão "Credits for the Resolver"
local enable_resolver_checkbox = ui.new_checkbox("Lua", "B", "Enable resolver")

-- Adiciona a checkbox "Enable resolver ESP flag" abaixo da checkbox "Enable resolver"
local enable_resolver_esp_checkbox = ui.new_checkbox("Lua", "B", "Enable resolver ESP flag")

-- Adiciona o botão "Credits for the Resolver"
local copy_link_button = ui.new_button("Lua", "B", "Credits for the Resolver", function()
    client.log("bernas198YT Discord Server: " .. url)
end)

local plist_set, plist_get = plist.set, plist.get
local getplayer = entity.get_players
local entity_is_enemy = entity.is_enemy
local entity_get_prop = entity.get_prop

-- Função para calcular o yaw baseado na direção do movimento
local function calculate_yaw(player)
    local velocity = entity_get_prop(player, "m_vecVelocity")
    
    -- Verifica se velocity é uma tabela e contém x e y
    if type(velocity) == "table" and velocity.x and velocity.y then
        local speed = math.sqrt(velocity.x^2 + velocity.y^2)

        -- Se o jogador está em movimento, ajusta o yaw
        if speed > 0 then
            local angle = math.atan2(velocity.y, velocity.x) * (180 / math.pi) -- Converte para graus
            return angle + math.random(-10, 10) -- Adiciona um pequeno desvio
        else
            return math.random(-60, 60) -- Se parado, usa um yaw aleatório
        end
    else
        -- Se não for uma tabela válida, retorna um yaw aleatório
        return math.random(-60, 60)
    end
end

-- Função para resolver a posição do jogador
local function resolve(player)
    -- Desativa a correção padrão
    plist_set(player, "Correction active", false)

    -- Calcula o yaw baseado na direção do movimento
    local yaw_value = calculate_yaw(player)
    plist_set(player, "Force body yaw", true)
    plist_set(player, "Force body yaw value", yaw_value)
end

-- Variável para controlar se a ESP flag foi registrada
local esp_flag_registered = false

-- Função para registrar a ESP flag
local function register_esp_flag()
    if esp_flag_registered then return end

    -- Registra a flag de ESP
    client.register_esp_flag("Resolved", 0, 255, 0, function(entindex)
        -- Verifica se a checkbox "Enable resolver ESP flag" está ativada
        if not ui.get(enable_resolver_esp_checkbox) then
            return false -- Retorna false para ocultar a flag
        end

        if not entity_is_enemy(entindex) then
            return false
        end

        -- Verifica se o yaw do corpo está forçado
        return plist_get(entindex, "Force body yaw") == true
    end)

    esp_flag_registered = true
end

-- Função chamada a cada atualização de rede
local function on_paint()
    -- Verifica se a checkbox "Enable resolver ESP flag" está ativada
    if ui.get(enable_resolver_esp_checkbox) then
        if not esp_flag_registered then
            register_esp_flag() -- Registra a ESP flag se ainda não estiver registrada
        end
    end

    local enemies = getplayer(true) -- Obtém todos os inimigos
    for i = 1, #enemies do
        local player = enemies[i]
        
        -- Verifica se a checkbox "Enable resolver" está ativada antes de aplicar o resolver
        if ui.get(enable_resolver_checkbox) then
            resolve(player) -- Resolve a posição do jogador
        end
    end
end

-- Define o callback para a atualização de rede
client.set_event_callback('paint', on_paint)