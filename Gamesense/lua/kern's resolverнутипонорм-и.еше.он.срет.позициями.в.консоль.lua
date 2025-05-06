local bit = require "bit"
local http = require "gamesense/http"
local ent = require "gamesense/entity"
local easing = require "gamesense/easing"
local base64 = require "gamesense/base64"
local vector = require "vector"
local images = require "gamesense/images"
local surface = require "gamesense/surface"
local clipboard = require "gamesense/clipboard"
local discord = require "gamesense/discord_webhooks"
local csgo_weapons = require "gamesense/csgo_weapons"
local antiaim_funcs = require "gamesense/antiaim_funcs"
local inspect = require 'gamesense/inspect'
local ffi = require 'ffi'

local tab, container = "LUA", "B"
local set, get = ui.set, ui.get

-- Define UI elements
local enable_resolver = ui.new_checkbox(tab, container, "Enable Resolver")
local resolver_mode = ui.new_combobox(tab, container, "Resolver Mode", "Kerns Resolver", "Automatic Bruteforce")

-- Weights for AI calculations
local ai_weights = {
    position = {
        automatic = 0.5,
        automatic_bruteforce = 0.5
    },
    velocity = {
        automatic = 0.5,
        automatic_bruteforce = 0.5
    },
    anti_aim = {
        automatic = 0.5,
        automatic_bruteforce = 0.5
    }
}

local function gather_player_data()
    local players = {}
    local player_count = globals.maxplayers()
    for i = 1, player_count do
        if entity.is_alive(i) then
            local player = {
                index = i,
                position = entity.get_origin(i),
                velocity = entity.get_prop(i, "m_vecVelocity"),
                anti_aim = entity.get_prop(i, "m_angEyeAngles")
            }
            table.insert(players, player)
        end
    end
    return players
end

local function ai_resolver(player, mode)
    local weights = {
        position = ai_weights.position[mode:lower()],
        velocity = ai_weights.velocity[mode:lower()],
        anti_aim = ai_weights.anti_aim[mode:lower()]
    }

    local resolved_data = {}
    resolved_data.resolved_position = vector(
        player.position.x * weights.position,
        player.position.y * weights.position,
        player.position.z * weights.position
    )
    resolved_data.resolved_velocity = vector(
        player.velocity.x * weights.velocity,
        player.velocity.y * weights.velocity,
        player.velocity.z * weights.velocity
    )
    resolved_data.resolved_anti_aim = vector(
        player.anti_aim.x * weights.anti_aim,
        player.anti_aim.y * weights.anti_aim,
        player.anti_aim.z * weights.anti_aim
    )
    return resolved_data
end

local function automatic_resolver()
    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) then return end  -- Ensure local player is alive

    local target = entity.get_prop(local_player, "m_hObserverTarget")
    if target and entity.is_alive(target) then
        local resolved_data = ai_resolver({
            index = target,
            position = entity.get_origin(target),
            velocity = entity.get_prop(target, "m_vecVelocity"),
            anti_aim = entity.get_prop(target, "m_angEyeAngles")
        }, "automatic")
        -- Return resolved data for further use
        return resolved_data
    end
end

local function automatic_bruteforce_resolver()
    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) then return end  -- Ensure local player is alive

    local players = gather_player_data()
    local target = entity.get_prop(local_player, "m_hObserverTarget")
    if target and entity.is_alive(target) then
        local best_resolve
        local best_score = -math.huge
        for _, player in ipairs(players) do
            if player.index ~= target then  -- Ensure target is not used as a player
                local resolved_data = ai_resolver(player, "automatic_bruteforce")
                local score = resolved_data.resolved_position:length() + resolved_data.resolved_velocity:length() + resolved_data.resolved_anti_aim:length()
                if score > best_score then
                    best_score = score
                    best_resolve = resolved_data
                end
            end
        end
        -- Return best resolved data for further use
        return best_resolve
    end
end

local function resolve_players()
    if not get(enable_resolver) then return end
    local mode = get(resolver_mode)
    if mode == "Kerns Resolver" then
        automatic_resolver()
    elseif mode == "Automatic Bruteforce" then
        automatic_bruteforce_resolver()
    else
        local players = gather_player_data()
        for _, player in ipairs(players) do
            local resolved_data = ai_resolver(player, mode)
            -- Print resolved data for debugging
            client.log(string.format("Player %d: Resolved Position: %s, Resolved Velocity: %s, Resolved Anti-Aim: %s",
                player.index,
                resolved_data.resolved_position:__tostring(),
                resolved_data.resolved_velocity:__tostring(),
                resolved_data.resolved_anti_aim:__tostring()
            ))
        end
    end
end

-- Track player deaths
local function on_player_death(event)
    if event and event.attacker == entity.get_local_player() then
        local victim_index = event.userid and client.userid_to_entindex(event.userid)
        if victim_index and entity.is_alive(victim_index) then
            local player = {
                index = victim_index,
                position = entity.get_origin(victim_index),
                velocity = entity.get_prop(victim_index, "m_vecVelocity"),
                anti_aim = entity.get_prop(victim_index, "m_angEyeAngles")
            }
            local mode = get(resolver_mode)
            local resolved_data
            if mode == "Kerns Resolver" then
                resolved_data = ai_resolver(player, "automatic")
            elseif mode == "Automatic Bruteforce" then
                resolved_data = ai_resolver(player, "automatic_bruteforce")
            else
                resolved_data = ai_resolver(player, mode)
            end

            -- Print resolved data for debugging
            client.log(string.format("Player %d killed: Resolved Position: %s, Resolved Velocity: %s, Resolved Anti-Aim: %s",
                victim_index,
                resolved_data.resolved_position:__tostring(),
                resolved_data.resolved_velocity:__tostring(),
                resolved_data.resolved_anti_aim:__tostring()
            ))
        end
    end
end

client.set_event_callback("paint", resolve_players)
client.set_event_callback("player_death", on_player_death)
client.log("Resolver script with advanced modes loaded successfully.")
