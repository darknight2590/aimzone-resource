ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Citizen.Wait(5000)
    ExecuteCommand("pvparena")
    ExecuteCommand("blips")
    TriggerEvent('maykılınevinde:dog')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if GetEntityMaxHealth(PlayerPedId()) ~= 200 then
            SetEntityMaxHealth(PlayerPedId(), 200)
            SetEntityHealth(PlayerPedId(), 200)
        end
    end
end)

-- Belirli süre içerisinde zırh verme
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(45000)
        local ped = PlayerPedId()
        AddArmourToPed(ped, 20)
        Citizen.Wait(1000)
        AddArmourToPed(ped, 10)
        Citizen.Wait(2000)
        AddArmourToPed(ped, 10)
        Citizen.Wait(1000)
        AddArmourToPed(ped, 20)
        Citizen.Wait(2000)
        AddArmourToPed(ped, 10)
        Citizen.Wait(1000)
        AddArmourToPed(ped, 10)
        Citizen.Wait(2000)
        AddArmourToPed(ped, 20)
    end
end)

local maykil = CircleZone:Create(vector3(-814.21, 180.657, 76.7453), 20.0, {
    name="lann",
    debugPoly=true,
})

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        maykilev = maykil:isPointInside(coords)
        if maykilev then
            SetEntityHealth(PlayerPedId(), 200)
            SetPedArmour(ped, 100)
        end
    end
end)

local iskuric = CircleZone:Create(vector3(-265.58, -962.55, 31.2231), 20.0, {
    name="allahuakbar",
    debugPoly=false,
})

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        iskur = iskuric:isPointInside(coords)
        if iskur then
            TriggerEvent('pvparena:spawn')
        end
    end
end)

-- Belirli bölgeye girdiğinde silah verme kodu

local aimz = CircleZone:Create(vector3(295.064, -2007.1, 20.2532), 150.0, {
    name="barrio",
    debugPoly=false,
})

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        pvpici = aimz:isPointInside(coords)
        if pvpici then
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_heavypistol"), 1000, false)
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_appistol"), 1000, false)
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_combatpdw"), 1000, false)
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_compactrifle"), 1000, false)
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_carbinerifle"), 1000, false)
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_knife"), 1, false)
            Citizen.Wait(150000)
        end
    end
end)

-- /pvparena yazarak spawn olabilirler
local PVPArenaSpawn = {
    [1] = {coords = vector3(262.125, -1997.5, 19.9434)}, 
    [2] = {coords = vector3(325.000, -2056.6, 27.3962)}, 
    [3] = {coords = vector3(209.495, -2017.1, 18.5576)}, 
}

RegisterNetEvent("pvparena:spawn")
AddEventHandler("pvparena:spawn", function()
local ped = PlayerPedId()
local random = math.random(1,3)

    SetEntityCoords(ped, PVPArenaSpawn[random].coords.x, PVPArenaSpawn[random].coords.y, PVPArenaSpawn[random].coords.z) 
end)

RegisterCommand('pvparena', function()
    TriggerEvent('pvparena:spawn')
end)

RegisterNetEvent('maykılınevinde:dog')
AddEventHandler('maykılınevinde:dog', function()
    local maledizhaha = PlayerPedId()
    
    SetEntityCoords(maledizhaha, -813.54, 179.595, 76.7453) 
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Prevent crashing.

		-- Stop Spawn
		SetCreateRandomCops(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetCreateRandomCopsOnScenarios(false)
		SetGarbageTrucks(false)
		SetRandomBoats(false)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetPedDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.5)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)

		-- Clear NPC
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
    end
end)

Citizen.CreateThread( function()
    while true do
       Citizen.Wait(0)
       RestorePlayerStamina(GetPlayerPed(999999), 9.0)
       end
   end)
