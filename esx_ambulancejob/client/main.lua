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

function GetDeath()
    if isDead then
        return true
    elseif not isDead then
        return false
    end
end

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

RegisterNetEvent('esx_ambulancejob:multicharacter')
AddEventHandler('esx_ambulancejob:multicharacter', function()
	isDead = false

	ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
		if isDead then
			-- TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
			OnPlayerDeath()
			isDead = true
			-- TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = _U('combatlog_message')})
			-- RemoveItemsAfterRPDeath()
		else 
			isDead = false
		end
	end)
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(25)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		-- BarrioInside = barrioZone:isPointInside(coords)
        if isDead then
			Citizen.Wait(150)
             SetPlayerInvincible(ped, false)
             ClearPedBloodDamage(ped)
             TriggerEvent('esx:onPlayerSpawn')
             ClearPedTasks(PlayerPedId())
			 TriggerEvent("aimz-randomspawn:barrio")
			 AddArmourToPed(ped, 100)
			 GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_heavypistol"), 1000, false)
			 GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_appistol"), 1000, false)
			 GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_combatpdw"), 1000, false)
			 GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_compactrifle"), 1000, false)
			 GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_carbinerifle"), 1000, false)
			 GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_knife"), 1, false)
        end
    end
end)

local BarrioKordinatlari = {
    [1] = {coords = vector3(207.64, -2005.22, 18.86)}, 
    [2] = {coords = vector3(225.63 , -2026.57, 18.1)}, 
    [3] = {coords = vector3(299.93, -2103.43, 17.32)}, 
    [4] = {coords = vector3(295.2, -2089.05, 23.85)}, 
    [5] = {coords = vector3(356.43, -2027.8, 28.69)}, 
    [6] = {coords = vector3(362.41, -1986.59, 24.23)},  
    [7] = {coords = vector3(422.06, -2037.15, 22.94)}, 
    -- [8] = {coords = vector3(x, y, z)},  
    -- [9] = {coords = vector3(x, y, z)}, 
    -- [10] = {coords = vector3(x, y, z)},  
    -- [11] = {coords = vector3(x, y, z)}, 
    -- [12] = {coords = vector3(x, y, z)}, 
}

RegisterNetEvent("aimz-randomspawn:barrio")
AddEventHandler("aimz-randomspawn:barrio", function()
local ped = PlayerPedId()
local random = math.random(1,7)

    SetEntityCoords(ped, BarrioKordinatlari[random].coords.x, BarrioKordinatlari[random].coords.y, BarrioKordinatlari[random].coords.z) 
end)

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 47, true)
			EnableControlAction(0, 245, true)
			EnableControlAction(0, 38, true)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
			EnableControlAction(0, 170, true)
			EnableControlAction(0, 182, true)
		else
			Citizen.Wait(500)
		end
	end
end)

function OnPlayerDeath()
	isDead = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)

	while not HasAnimDictLoaded("dead") do
		RequestAnimDict("dead")
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
end

function loadAnimDict( dict )
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterCommand('yenile', function()
	if isDead then
		-- if not IsEntityPlayingAnim(PlayerPedId(), 'dead', 'dead_a', 3) then
			ClearPedTasks(PlayerPedId())
			TaskPlayAnim(PlayerPedId(), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0 )
		-- end
	else
		local ped = PlayerPedId()
		local ped_armor = GetPedArmour(ped)
		local ped_health = GetEntityHealth(ped)
		local Model = GetEntityModel(ped)
		if Model ~= nil then
			if IsModelValid(Model) then
				if not HasModelLoaded(Model) then
					RequestModel(Model)
					while not HasModelLoaded(Model) do
						Citizen.Wait(5)
					end
				end
				
				SetPlayerModel(PlayerId(), Model)
				SetModelAsNoLongerNeeded(Model)
	
				Citizen.Wait(10)
	
				SetPedRandomProps(PlayerPedId())
				-- SetPedRandomComponentVariation(PlayerPedId(), true)

				Citizen.Wait(10)
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
				exports['dpclothing']:ResetClothing()
				SetPedArmour(PlayerPedId(), ped_armor)
				SetEntityHealth(PlayerPedId(), ped_health)
			end
		end

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
				canCancel = true,
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
					TriggerServerEvent('esx_ambulancejob:removeItem','medikit')
				end
			end)

		elseif itemName == 'bandage' then
			exports['mythic_progbar']:Progress({
				name = "bandage",
				duration = 6000,
				label = 'Bandaj kullanılıyor...',
				useWhileDead = false,
				canCancel = true,
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
					TriggerServerEvent('esx_ambulancejob:removeItem','bandage')
				end
			end)
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Yerdeyken bunu kullanamazsın!'})
	end
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local pressed = 0
		local timer = Config.BleedoutTimer

		while timer > 0 and isDead and pressed < 2 do
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
			AddTextComponentSubstringPlayerName('')
			EndTextCommandDisplayText(0.501, 0.839)

			if IsControlJustReleased(0, 47) then
				SendDistressSignal()
				pressed = pressed + 1
			end
		end
	end)
end

function SendDistressSignal()
	local plyPed = PlayerPedId()
	local plyPos = GetEntityCoords(plyPed)
    TriggerServerEvent("emsihbar2", plyPos)
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
	local canPayFine = true
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
			DrawText(0.5, 0.89)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(0)
			text = "HASTANEDE DOGMAK ICIN [~r~E~w~] TUSUNA BASILI TUT VEYA DOKTOR BEKLE"
			-- text = text .. _U('respawn_bleedout_prompt')

			if IsControlPressed(0, 38) and timeHeld > 30 then
				RemoveItemsAfterRPDeath()
				break
			end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.95)
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

			ESX.SetPlayerData('loadout', {})
			RespawnPed(PlayerPedId(), formattedCoords, Config.RespawnPoint.heading)

			-- StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
			TriggerEvent('esx_status:remove', 'hunger', 300000)
			TriggerEvent('esx_status:remove', 'thirst', 300000)
		end)
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
	

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	-- TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
	-- TriggerEvent('esx_ambulancejob:multicharacter', coords.x, coords.y, coords.z)
	-- SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	-- NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	-- SetPlayerInvincible(ped, false)
	-- TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	-- ClearPedBloodDamage(ped)

	-- ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('fightclub')
AddEventHandler('fightclub', function()
	local formattedCoords = {
		x = 899.7525,
		y = -1808.88,
		z = 24.967
	}
	RespawnPed(PlayerPedId(), formattedCoords, 250.0)
end)

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
