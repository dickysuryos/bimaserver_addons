
local StockadeSpawned = false
local stockade = nil
local driver = nil
local policeCars = {}
local robberyInProgress = false
local isRobbing = false
local stockadeTrunkCoords = nil
local currentloc = nil
-- Function to spawn Stockade with NPC driver and police cover vehicles
function spawnStockadeWithNPC()
    Citizen.Wait(1000)
    if StockadeSpawned then return end
    StockadeSpawned = true
    local loc = Config.ATMLocations[math.random(#Config.ATMLocations)]
    currentloc = loc
    -- Randomize the spawn location and route for the Stockade
    local location = Config.StockadeLocations[math.random(#Config.StockadeLocations)]
    
    RequestModel(Config.StockadeModel)
    RequestModel('s_m_m_security_01') -- NPC Model
    RequestModel('police')
    RequestModel('s_m_y_cop_01')
    while not HasModelLoaded('s_m_m_security_01') do
      Citizen.Wait(1)
    end
    Citizen.Wait(5000)
    while not HasModelLoaded('police') and not HasModelLoaded('s_m_y_cop_01') do
        Citizen.Wait(1)
      end
    if stockade == nil and driver == nil then
        stockade = CreateVehicle(GetHashKey(Config.StockadeModel),location.x,location.y,location.z,277.1201,true,false)
        driver = CreatePedInsideVehicle(stockade, 6, 's_m_m_security_01', -1, true, false)
        SetPedCombatRange(driver,3)
        SetPedCombatAbility(driver, 2)
        SetPedCombatAttributes(driver,12, true)
        SetPedCombatAttributes(driver,27, true)
    end
    
  
    -- TaskVehicleDriveWander(driver, stockade, 20.0, 786603)  -- Make NPC drive
    -- Citizen.Wait(2000)
    SetEntityAsMissionEntity(driver, true, true)
    SetDriverAbility(driver, 1.0)
    SetPedFleeAttributes(driver,0,false)
    SetVehicleEngineOn(stockade,true,true,true)
    SetVehicleFuelLevel(stockade, 100.0)
    GiveWeaponToPed(driver, GetHashKey("weapon_microsmg"), 255, true, true)
    DecorSetFloat(stockade, '_FUEL_LEVEL', 100.0)
    TaskVehicleDriveToCoordLongrange(driver,stockade,loc.x,loc.y,loc.z,100.0,786623,5.0)
    SetVehicleOnGroundProperly(stockade)
    -- policeCars = CreateVehicle(GetHashKey('police'), location.x, location.y - 20, location.z, location.w, true, false)
    -- local policeDriver = CreatePedInsideVehicle(policeCars, 4, 's_m_y_cop_01', -1, true, false)
    -- TaskVehicleFollow(policeDriver,policeCars,stockade,100.0,786623,50)
    -- SetVehicleOnGroundProperly(policeCars)
    -- Spawn police cover vehicles
    for i = 1, 1 do
       
        local policeCar = CreateVehicle(GetHashKey('police'), location.x, location.y - 20, location.z, 277.1201, true, false)
        local policeDriver = CreatePedInsideVehicle(policeCar, 4, 's_m_y_cop_01', -1, true, false)
        -- TaskVehicleDriveWander(policeDriver, policeCar, 20.0, 786603) -- Make police cars drive
        SetPedCombatRange(policeDriver,3)
        SetPedCombatAbility(policeDriver, 2)
        SetPedCombatAttributes(policeDriver,12, true)
        SetPedCombatAttributes(policeDriver,27, true)
        TaskVehicleFollow(policeDriver,policeCar,stockade,100.0,786623,20)
        SetVehicleOnGroundProperly(policeCar)
        SetPedRelationshipGroupHash(policeDriver,  GetHashKey('COP'))
        SetPedRelationshipGroupHash(driver,  GetHashKey('COP'))
        GiveWeaponToPed(policeDriver, GetHashKey("weapon_microsmg"), 255, true, true)
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
        -- print(stockade)
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
            robberyInProgress = false
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
        Citizen.Wait(30000)  -- Wait 1 minute before spawning another Stockade
        spawnStockadeWithNPC()
    end
end)
Citizen.CreateThread(function ()
    while true do
    Citizen.Wait(60000)
    if StockadeSpawned and #(currentloc - stockadeTrunkCoords) < 20 then
        print('change the lane')
        ClearPedTasks(driver)
        Citizen.Wait(2000)
        local loc = Config.ATMLocations[math.random(#Config.ATMLocations)]
        TaskVehicleDriveToCoordLongrange(driver,stockade,loc.x,loc.y,loc.z,60,786475,10)
        end
    end
end)

-- Create a thread to check for player position and display the marker
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if StockadeSpawned and IsVehicleStopped(stockade) then
            -- Get the coordinates of the trunk (assuming it's the rear of the vehicle)
            stockadeTrunkCoords = GetOffsetFromEntityInWorldCoords(stockade, 0.0, -3.0, 0.0)
            -- print(stockade)
        
            -- Display the marker at the trunk
            DrawMarker(1, stockadeTrunkCoords.x, stockadeTrunkCoords.y, stockadeTrunkCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 0, 0, 100, false, true, 2, nil, nil, false)

            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            -- print( GetDistanceBetweenCoords(coords, stockadeTrunkCoords, true))
            -- Check if player is within 2.5 units of the trunk
            if GetDistanceBetweenCoords(coords, stockadeTrunkCoords, true) < 2.5 then
                if not isRobbing then
                    ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to rob the Stockade")

                    if IsControlJustReleased(0, 51) then -- 'E' key press
                        -- Start the progress bar
                        TriggerEvent('esx:showNotification', "Starting robbery...")
                        TriggerEvent(
                            "mythic_progbar:client:progress",
                            {
                                name = "Robbing",
                                duration = 5000,
                                label = "Robbing.....",
                                useWhileDead = false,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true
                                }
                            },
                            function(status)
                                if not status then
                                TriggerServerEvent('esx_robbery:completeStockadeRobbery')
                                isRobbing = false
                                else
                                TriggerEvent('esx:showNotification', "Robbery canceled.")
                                isRobbing = false
                                end
                            end
                        )
                        TriggerEvent("esx_progressbar:start", "Robbing the Stockade", 10000, {
                            onComplete = function()
                                -- Robbery completed successfully
                                TriggerServerEvent('esx_robbery:completeStockadeRobbery')
                                isRobbing = false
                            end,
                            onCancel = function()
                                -- Robbery canceled
                                TriggerEvent('esx:showNotification', "Robbery canceled.")
                                isRobbing = false
                            end
                        })
                        isRobbing = true
                    end
                end
            elseif isRobbing then
                -- Player left the area while robbing, cancel progress
                TriggerEvent('esx_progressbar:cancel')
                isRobbing = false
            end
        end
    end
end)

RegisterNetEvent('esx_progressbar:start')
AddEventHandler('esx_progressbar:start', function(action, duration, options)
    -- Start the progress bar for 'duration' milliseconds with the provided options
end)

RegisterNetEvent('esx_progressbar:cancel')
AddEventHandler('esx_progressbar:cancel', function()
    -- Cancel the progress bar if the player leaves the area
end)