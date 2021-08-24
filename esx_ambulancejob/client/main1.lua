--[[ DUMPED USING COMPOSER DEVIL ]]--
local firstSpawn, PlayerLoaded = true, false

isDead = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx:onPlayerSpawn', function()
	isDead = false

	if firstSpawn then
		firstSpawn = false

		if Config.AntiCombatLog then
			while not PlayerLoaded do
				Citizen.Wait(1000)
			end

			ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
				if shouldDie then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = _U('combatlog_message')})
					RemoveItemsAfterRPDeath()
				end
			end)
		end
	end
end)

function notif(type, text, length)
	TriggerEvent('mythic_notify:client:SendAlert', { type = type , text = text, lenght})
end

function GetDeath()
	if isDead then
	return true
	else
	return false
	end
end

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isDead then
			DisableAllControlActions(0)
			DisableControlAction(0, 45, true)
			EnableControlAction(0, 47, true)
			EnableControlAction(0, 245, true)
			EnableControlAction(0, 38, true)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
		else
			Citizen.Wait(500)
		end
	end
end)

function OnPlayerDeath()
	isDead = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)

	while not HasAnimDictLoaded("misslamar1dead_body") do
		RequestAnimDict("misslamar1dead_body")
		Citizen.Wait(10)
	end

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	local coords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0.0, true, false)
	SetPlayerInvincible(ped, true)
	SetEveryoneIgnorePlayer(ped, true)
	SetPoliceIgnorePlayer(ped, true)

	StartDeathTimer()
	StartDistressSignal()

	-- while isDead do
	-- 	SetPlayerInvincible(PlayerId(), true)
	-- 	SetEntityInvincible(PlayerPedId(-1), true)
	-- 	if not IsPedSittingInAnyVehicle(PlayerPedId()) then
	-- 		if not IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) then
	-- 			TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 500.0, 1.0, -1, 33, 0, 0, 0, 0 )
	-- 		end
	-- 	else
	-- 		ClearPedTasks(PlayerPedId())
	-- 	end
	-- 	Citizen.Wait(0)
	-- end

	repeat
		SetPlayerInvincible(PlayerId(), true)
		SetEntityInvincible(PlayerPedId(-1), true)
		if not IsPedSittingInAnyVehicle(PlayerPedId()) then
			if not IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) then
				TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 500.0, 1.0, -1, 33, 0, 0, 0, 0 )
			end
		else
			ClearPedTasks(PlayerPedId())
		end
		Citizen.Wait(0)
	until not isDead

	-- StartScreenEffect('DeathFailOut', 0, false)
end

function loadAnimDict( dict )
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterCommand('yenile', function()
	if isDead then
		-- if not IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) then
			ClearPedTasks(PlayerPedId())
			TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 500.0, 1.0, -1, 33, 0, 0, 0, 0 )
		-- end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bu komut sadece yaralıyken kullanılabilir.'})
	end
end)

RegisterCommand("hastanefix", function()
	local playerPed = PlayerPedId()
	if #(GetEntityCoords(playerPed) - vector3(289.2, -585.33, 17.76)) < 200.0 then
		if isDead then
			ESX.Game.Teleport(playerPed, vector3(299.7, -581.16, 43.26))
		else
			exports['mythic_notify']:DoHudText('inform', 'Bu Komutu Ölü İken Kullanabilirsin')
		end
	else
		exports['mythic_notify']:DoHudText('inform', 'Bu Komutu Burada Kullanamazsın')
	end
end)

RegisterCommand('acil', function(source, args) 
	if ESX.PlayerData.job and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' ) and isDead then
	  SendDistressSignalPolice()
	else
		exports['mythic_notify']:SendAlert('error', "Bu komutu kullanmak için polis/sheriff ve yaralı olmalısın")
	end
end)

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()
	local pPed = PlayerPedId()

	if not IsPedRagdoll(pPed) then
		if itemName == 'medikit' then
			exports['mythic_progbar']:Progress({
				name = "medkit",
				duration = 12000,
				label = 'Medkit kullanılıyor...',
				useWhileDead = false,
				canCancel = false,
				controlDisables = {
					disableMovement = false,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "missheistdockssetup1clipboard@idle_a",
					anim = "idle_a",
					flags = 49,
				},
				prop = {
					model = "prop_stat_pack_01"
				},
			}, function(cancelled)
				if not cancelled then
					TriggerEvent('esx_ambulancejob:heal', 'big', true)
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = _U('used_medikit')})
				end
			end)

		elseif itemName == 'bandage' then
			exports['mythic_progbar']:Progress({
				name = "bandage",
				duration = 6000,
				label = 'Bandaj kullanılıyor...',
				useWhileDead = false,
				canCancel = false,
				controlDisables = {
					disableMovement = false,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "clothingshirt",
					anim = "try_shirt_neutral_d",
					flags = 49,
				},
			}, function(cancelled)
				if not cancelled then
					TriggerEvent('esx_ambulancejob:heal', 'small', true)
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = _U('used_bandage')})
				end
			end)
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Yerdeyken bunu kullanamazsın!'})
	end
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer

		while timer > 0 and isDead do
			Citizen.Wait(0)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextCentre(true)
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName('~w~SINYAL GONDERMEK IÇIN [~r~G~w~] BAS' )
			EndTextCommandDisplayText(0.499, 0.890)

			if IsControlJustReleased(0, 47) then
				SendDistressSignal()
				TriggerEvent('esx-ambulancejob:downplayer')
				break
			end
		end
	end)
end

-- function SendDistressSignal()
-- 	local plyPed = PlayerPedId()
-- 	local plyPos = GetEntityCoords(plyPed)
--     TriggerServerEvent("emsihbar2", plyPos)
-- end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = _U('distress_sent')})
	local myPos = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('gcPhone:sendMessage', "ambulance", "Yaralı var! Konum:" .. myPos.x .. ', ' .. myPos.y, true)
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end


function StartDeathTimer()
	local canPayFine = false

	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(0)
			text = ""

			DrawGenericTextThisFrame()

			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.94)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(0)
			text = "HASTANEDE DOGMAK ICIN [~r~E~w~] TUSUNA BASILI TUT VEYA DOKTOR BEKLE"

			if not Config.EarlyRespawnFine then
				-- text = text .. _U('respawn_bleedout_prompt')

				if IsControlPressed(0, 38) and timeHeld > 60 then
					RemoveItemsAfterRPDeath()
					break
				end
			elseif Config.EarlyRespawnFine and canPayFine then
				-- text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

				if IsControlPressed(0, 38) and timeHeld > 60 then
					TriggerServerEvent('esx_ambulancejob:payFine')
					RemoveItemsAfterRPDeath()
					break
				end
			end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.92)
		end

		if bleedoutTimer < 1 and isDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

function RemoveItemsAfterRPDeath()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local formattedCoords = {
				x = Config.RespawnPoint.coords.x,
				y = Config.RespawnPoint.coords.y,
				z = Config.RespawnPoint.coords.z
			}
			
			
			if ESX.PlayerData.job.name == 'police' then
				polisDogma()
				notif("inform", "Polis olduğun için karakolda doğdun.", 2500)
				TriggerEvent('m3:inventoryhud:client:clearFast')
			else
				ESX.SetPlayerData('loadout', {})
				RespawnPed(PlayerPedId(), formattedCoords, Config.RespawnPoint.heading)
				TriggerEvent('m3:inventoryhud:client:clearFast')

				DoScreenFadeIn(800)
			end
		end)
	end)
end

function polisDogma()
	local ply = PlayerPedId()
	ESX.SetPlayerData('loadout', {})
	DoScreenFadeIn(800)
	SetEntityCoordsNoOffset(ped, 441.60, -982.37, 30.67, false, false, false, true)
	NetworkResurrectLocalPlayer(441.60, -982.37, 30.67, 1, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
	

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
	SetEntityCoords(ply, 441.60, -982.37, 30.67)
	TriggerServerEvent("esx_ambulancejob:polisitemver", "WEAPON_NIGHTSTICK", 1)
	TriggerServerEvent("esx_ambulancejob:polisitemver", "WEAPON_COMBATPISTOL", 1)
	TriggerServerEvent("esx_ambulancejob:polisitemver", "disc_ammo_pistol", 5)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
	

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	Citizen.Wait(3000)
	OnPlayerDeath()
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	RespawnPed(playerPed, formattedCoords, 0.0)

	-- StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
end)

-- Load unloaded IPLs
if Config.LoadIpl then
	RequestIpl('Coroner_Int_on') -- Morgue
end

--[[ DUMPED USING COMPOSER DEVIL ]]--