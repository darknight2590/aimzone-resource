
ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local firstSpawn = true
AddEventHandler('playerSpawned', function()
    if firstSpawn then
        for _, v in pairs(Config.Buttons) do
            SetDiscordRichPresenceAction(v.index, v.name, v.url)
        end
        firstSpawn = false
    end
end)

local playercount, name = 0, nil
Citizen.CreateThread(function()
	-- while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(878239515590930454) -- bak bunu editlemen lazım yoksa sorun çıkar

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('aimzone') 
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('AIM ZONE')
       
        --Here you will have to put the image name for the "small" icon.
        -- SetDiscordRichPresenceAssetSmall('onayli')

        --Here you can add hover text for the "small" icon.
        -- SetDiscordRichPresenceAssetSmallText('Doğrulandı')

        --It updates every one minute just in case.
		-- Citizen.Wait(10)
	-- end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		
		SetRichPresence(GetPlayerName(PlayerId()))
	end
end)