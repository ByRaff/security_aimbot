ESX = exports['es_extended']:getSharedObject()

local Cooldown = {}

CreateThread(function()
    while true do
        Wait(10000)
        Cooldown = {}
    end
end)

function GetAllIdentifiers(playerId)
    local string = ''

    for k, v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.find(v, 'steam') then
            string = string .. v
        elseif string.find(v, 'license') then
            stringw = string .. '\n' .. v
        elseif string.find(v, 'xbl') then
            string = string .. '\n' .. v
        elseif string.find(v, 'discord') then
            string = string .. '\n' .. v
        elseif string.find(v, 'live') then
            string = string .. '\n' .. v
        elseif string.find(v, 'fivem') then
            string = string .. '\n' .. v
        end
    end

    return string
end
 

local function Log(playerId, title, message, webhook)
    local embed = {
        {
            ['color'] = '3447003',
            ['title'] = '**' .. title .. '**',
            ['description'] = message .. '\n ```' .. GetAllIdentifiers(playerId) .. '```',
            ['footer'] = {
                ['text'] = 'BB-RP - '.. os.date('%d.%m.%y') .. ' - ' .. os.date('%X') .. ' Uhr',
                ['icon_url'] = 'https://www.bb-rp.de/img/logo.png',
            },
            ['author'] = {
                ['name'] = 'BB-RP',
                ['url'] = 'https://discord.gg/bb-rp',
                ['icon_url'] = 'https://www.bb-rp.de/img/logo.png',
            }
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'BB-RP', embeds = embed, avatar_url = 'https://www.bb-rp.de/img/logo.png'}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('bb_executediesencommandundbekommedeintraumauto:byraffgönnt', function(target)
    if target ~= nil then
        if not Cooldown[source] then
            Cooldown[source] = true
            if GetPlayerName(target) ~= nil then
                Log(source, '**Anti-Aim**', 'Der Spieler '..GetPlayerName(source)..' **Aim Tracked**: '..GetPlayerName(target)..' Auffällig!', 'https://discord.com/api/webhooks/1240762396570550302/P63fBZZioqX-iRhLrE322j4lJhqNZmUjfxMLxw23hSwOPar_Po0TEbxulmocYGaxKLC8')
            end
        end
    end
end)