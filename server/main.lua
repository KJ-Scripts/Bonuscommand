ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local claimed = json.decode(LoadResourceFile("KJ-Bonus", "claimed.json")) or {}

RegisterCommand('bonus', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    if not claimed[identifier] then
        claimed[identifier] = true

        xPlayer.addAccountMoney('bank', 20000)

        SaveResourceFile("KJ-Bonus", "claimed.json", json.encode(claimed, { indent = true }), -1)

        local steamName = GetPlayerName(source)
        local playerName = xPlayer.getName()
        local steamID = xPlayer.getIdentifier()
        local bankMoney = formatNumber(xPlayer.getAccount('bank').money)
        local cashMoney = formatNumber(xPlayer.getMoney())
        local rockstarLicense = xPlayer.getIdentifier('license')
        local purchaseTime = os.date('%Y-%m-%d %H:%M:%S') 

        local logMessage = string.format(
            "Tijd en Datum: %s\nSteam Naam: %s\nIn-game Naam: %s\nSteam ID: %s\nRockstar License: %s\nBank: %s\nCash: %s",
            purchaseTime, steamName, playerName, steamID, rockstarLicense, bankMoney, cashMoney
        )

        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/13107043167031297/Srq8mLZSOAgCdmKyJwvU0QyqANbqxDbLNsWYgqlojGGMtO6V92H4I4e', source, {
            title = "Bonus Command Logs",
            desc = logMessage
        })

        -- Ox_lib melding
        TriggerClientEvent('ox_lib:notify', source, {
            title = "Bonus",
            description = "Je hebt succesvol je bonus van 20.000 geclaimed!",
            type = "success"
        })

        -- Optioneel: Chatbericht toevoegen
        TriggerClientEvent('chat:addMessage', source, {
            args = { "[BONUS]", "Je hebt succesvol je bonus van 20.000 geclaimed!" },
            color = { 0, 255, 0 } -- Groen
        })
    else
        -- Ox_lib melding bij herclaim poging
        TriggerClientEvent('ox_lib:notify', source, {
            title = "Bonus",
            description = "Je hebt je bonus al geclaimed en kunt dit niet opnieuw doen!",
            type = "error"
        })

        -- Optioneel: Chatbericht toevoegen
        TriggerClientEvent('chat:addMessage', source, {
            args = { "[BONUS]", "Je hebt je bonus al geclaimed en kunt dit niet opnieuw doen!" },
            color = { 255, 0, 0 } -- Rood
        })
    end
end)

function formatNumber(number)
    local formatted = tostring(number)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end
