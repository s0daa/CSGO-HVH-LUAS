--[[

    Thanks for use us!
    We are the best free & open lua (https://docs.gamesense.gs/docs/api) for https://gamesense.pub (https://unk.is)
    Created by @javasense

    Special Thanks: Shiza(@cynosatech), Fewiz(@ptgod), zxkilla(@dzhigit1337), Perc(@lordmouse), Kors(@il2cppdumper), Jakscio(@jakscio), XaNe(@xane1337), Shameless(shumless), angelvec(dead irl)

    discord server: https://dsc.gg/antariusgg

    2024 ~ antarctica.scripts

]]

local http = require 'gamesense/http'
http.get('https://raw.githubusercontent.com/anarchisrt/antarctica/main/antarcticav2.lua', function(success, response)
    if not success or response.status ~= 200 then
        client.color_log(215, 55, 55, '[-] Load failed')
        return
    end
    pcall(load(response.body, 'antarctica'))
end)