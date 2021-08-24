ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler("baseevents:onPlayerKilled", function(player, killer, reason, pos)
    TriggerClientEvent('XNL_NET:AddPlayerXP', TargetClient , 5000, killer)
end)