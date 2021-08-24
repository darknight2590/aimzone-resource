Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = {type = 2, x = 0.2, y = 0.2, z = 0.2, r = 255, g = 255, b = 255, a = 100, rotate = true}

Config.ReviveReward               = 400  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = false -- enable anti-combat logging?
Config.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

Config.EarlyRespawnTimer          = 60000 * 10  -- time til respawn is available
Config.BleedoutTimer              = 5 * 30 -- time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 80

Config.RespawnPoint = {coords = vector3(313.82, -565.34, 43.28), heading = 74.65}

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(297.78, -584.33, 43.26),   
			sprite = 489,
			scale  = 0.8,
			color  = 1
		},

		AmbulanceActions = {
			vector3(306.814, -601.68, 43.4245)
		},

		-- Pharmacies = {
		-- 	vector3(230.1, -1366.1, 38.5)
		-- },

		Vehicles = {
			{
				Spawner = vector3(294.64, -600.89, 43.3),   
				InsideShop = vector3(297.77, -578.96, 49.65),
				Marker = { type = 36, x = 0.6, y = 0.6, z = 0.6, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(295.1, -607.27, 43.33), heading = 68.99, radius = 4.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(340.24, -590.02, 74.07),   
				InsideShop = vector3(352.22, -588.47, 74.07),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(352.22, -588.47, 74.07), heading = 29.1, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			{
				From = vector3(294.7, -1448.1, 29.0),
				To = {coords = vector3(272.8, -1358.8, 23.5), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(275.3, -1361, 23.5),
				To = {coords = vector3(295.8, -1446.5, 28.9), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(247.3, -1371.5, 23.5),
				To = {coords = vector3(333.1, -1434.9, 45.5), heading = 138.6},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(335.5, -1432.0, 45.50),
				To = {coords = vector3(249.1, -1369.6, 23.5), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(234.5, -1373.7, 20.9),
				To = {coords = vector3(320.9, -1478.6, 28.8), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(317.9, -1476.1, 28.9),
				To = {coords = vector3(238.6, -1368.4, 23.5), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(237.4, -1373.8, 26.0),
				To = {coords = vector3(251.9, -1363.3, 38.5), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
				Prompt = _U('fast_travel')
			},

			{
				From = vector3(256.5, -1357.7, 36.0),
				To = {coords = vector3(235.4, -1372.8, 26.3), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
				Prompt = _U('fast_travel')
			}
		}

	}
}

Config.AuthorizedVehicles = {
	car = {
		ambulance = {
			{ model = 'emsc', label = 'Ambulans', price = 100},
			{ model = 'emsf', label = 'Ambulans', price = 100},
			{ model = 'emst', label = 'Ambulans', price = 100},
			{ model = 'emsv', label = 'Ambulans', price = 100},
			{ model = 'ambulance', label = 'Ambulans', price = 100},
		},
	
		doctor = {
			{ model = 'emsc', label = 'Ambulans', price = 100},
			{ model = 'emsf', label = 'Ambulans', price = 100},
			{ model = 'emst', label = 'Ambulans', price = 100},
			{ model = 'emsv', label = 'Ambulans', price = 100},
			{ model = 'ambulance', label = 'Ambulans', price = 100},
		},
	
		chief_doctor = {
			{ model = 'emsc', label = 'Ambulans', price = 100},
			{ model = 'emsf', label = 'Ambulans', price = 100},
			{ model = 'emst', label = 'Ambulans', price = 100},
			{ model = 'emsv', label = 'Ambulans', price = 100},
			{ model = 'ambulance', label = 'Ambulans', price = 100},
		},
	
		boss = {
			{ model = 'emsc', label = 'Ambulans', price = 100},
			{ model = 'emsf', label = 'Ambulans', price = 100},
			{ model = 'emst', label = 'Ambulans', price = 100},
			{ model = 'emsv', label = 'Ambulans', price = 100},
			{ model = 'ambulance', label = 'Ambulans', price = 100},
		}
	},

	helicopter = {
		ambulance = {},

		doctor = {
			{ model = 'emsair', label = 'Ambulans Helikopteri', price = 1000 }
		},

		chief_doctor = {
			{ model = 'emsair', label = 'Ambulans Helikopteri', price = 1000 }
		},

		boss = {
			{ model = 'emsair', label = 'Ambulans Helikopteri', price = 1000 }
		}
	}
}
