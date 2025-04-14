-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--> How to utilize obex macros
local obex_data = obex_fetch and obex_fetch() or {username = 'Bigdon', build = 'Source'}

--> Setup requirements
local vector = require('vector')

--> How to utilize heartbeat macro, it'll get replaced when obfuscated, should maximum be in 1-2 event callbacks
client.set_event_callback('paint', function()
    -- The comment below with the @ adds a heartbeat to whatever callback
    -- you add it to and it'll run every 300 seconds, recommended to
    -- only add it to a single callback, the code will be put in the
    -- place instead of the comment.

    --@heartbeat

    --> do ur regular drawing shit
    local screen_size = vector(client.screen_size())
    local example_text = (('%s  -  %s'):format(obex_data.username, obex_data.build)):upper()

    renderer.text(screen_size.x / 2, screen_size.y / 2 + 20, 255, 255, 255, 255, 'c-', 0, example_text)
end)