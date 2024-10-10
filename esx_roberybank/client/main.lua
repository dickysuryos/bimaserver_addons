
local StockadeSpawned = false
local stockade = nil
local driver = nil
local policeCars = {}
local robberyInProgress = false


-- Function to spawn Stockade with NPC driver and police cover vehicles
function spawnStockadeWithNPC()
    if StockadeSpawned then return end

    -- Randomize the spawn location and route for the Stockade
    local location = Config.StockadeLocations[math.random(#Config.StockadeLocations)]
    
    RequestModel(Config.StockadeModel)
    RequestModel('s_m_m_security_01') -- NPC Model
    while not HasModelLoaded(Config.StockadeModel) or not HasModelLoaded('s_m_m_security_01') do
        Citizen.Wait(1)
    end

    -- Spawn Stockade and assign NPC driver
    stockade = CreateVehicle(GetHashKey(Config.StockadeModel), location.x, location.y, location.z, true, false)
    driver = CreatePedInsideVehicle(stockade, 4, 's_m_m_security_01', -1, true, false)
    TaskVehicleDriveWander(driver, stockade, 20.0, 786603)  -- Make NPC drive

    SetVehicleOnGroundProperly(stockade)

    -- Spawn police cover vehicles
    for i = 1, 2 do
        local policeCar = CreateVehicle(GetHashKey('police'), location.x + math.random(-5, 5), location.y + math.random(-5, 5), location.z, true, false)
        local policeDriver = CreatePedInsideVehicle(policeCar, 4, 's_m_y_cop_01', -1, true, false)
        TaskVehicleDriveWander(policeDriver, policeCar, 20.0, 786603) -- Make police cars drive
        SetVehicleOnGroundProperly(policeCar)
        table.insert(policeCars, policeCar)
    end

    StockadeSpawned = true
    robberyInProgress = false
end

-- Robbing the Stockade
RegisterNetEvent('esx_robbery:robStockade')
AddEventHandler('esx_robbery:robStockade', function()
    if not robberyInProgress then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        -- Check if the player is close enough to the Stockade
        if GetDistanceBetweenCoords(coords, GetEntityCoords(stockade), true) < 5.0 then
            -- Make NPC driver stop the vehicle
            TaskLeaveVehicle(driver, stockade, 0)
            TaskCombatPed(driver, playerPed, 0, 16)  -- Make NPC driver attack the player

            -- Open trunk and allow player to take money bag
            SetVehicleDoorOpen(stockade, 5, false, false)

            ESX.TriggerServerCallback('esx_robbery:giveMoneyBag', function(success)
                if success then
                    TriggerEvent('esx:showNotification', 'You have taken a money bag!')
                    loadAnimDict('anim@heists@box_carry@')
                    TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 50, 0, false, false, false)

                    Citizen.Wait(5000)
                    -- Load the bag into the car or put it into inventory
                    TriggerServerEvent('esx_robbery:loadMoneyBag')
                else
                    TriggerEvent('esx:showNotification', 'You cannot carry any more bags!')
                end
            end)

            robberyInProgress = true
        else
            TriggerEvent('esx:showNotification', 'You are too far from the Stockade!')
        end
    else
        TriggerEvent('esx:showNotification', 'Robbery already in progress!')
    end
end)

-- Load the animation dictionary
function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
end

-- Trigger spawn of Stockade
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)  -- Wait 1 minute before spawning another Stockade
        spawnStockadeWithNPC()
    end
end)
