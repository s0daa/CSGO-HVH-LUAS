------@libs
local ffi = require("ffi")
local c_entity = require("gamesense/entity")
local color = require ("gamesense/color")
local pui = require("gamesense/pui")
local http = require("gamesense/http")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local websocket = require("gamesense/websockets")
local vector = require("vector")
local c_entity = require('gamesense/entity')
local json = require("json")
------@libs

local ref = {
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
    yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
    safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
    roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
    clantag = ui.reference('Misc', 'Miscellaneous', 'Clan tag spammer'),
    fakelag = ui.reference("AA", "Fake lag", "Limit"),
    
    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
    yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
    bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
    freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
    slow = { ui.reference('AA', 'Other', 'Slow motion') },
    os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
    slow = { ui.reference('AA', 'Other', 'Slow motion') },
    dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
    leg_movement = ui.reference('AA', 'Other', "Leg movement"),
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") },
    
    menu_color = ui.reference("Misc", "Settings", "Menu color"),
    mates = ui.reference("Visuals", "Player ESP", "Teammates"),
    
    bunnyhop = ui.reference("Misc", "Movement", "Bunny hop"),
    autostrafe = ui.reference("Misc", "Movement", "Air strafe"),
    scope_overlay = pui.reference('Visuals', 'Effects', 'Remove scope overlay'),
    }

client.exec("Clear")

local lua_menu = {
    s 1 aprela = 
}


