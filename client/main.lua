ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Suggestie toevoegen voor het bonuscommando
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/bonus', 'Claim jouw bonus!')
end)
