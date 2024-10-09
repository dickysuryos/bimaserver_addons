-- This resource was made by plesalex100#7387
-- Please respect it, don't repost it without my permission
-- This Resource started from: https://codepen.io/AdrianSandu/pen/MyBQYz

local open = false
local langaAparat = false

local function drawHint(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

CreateThread(function()
	if Cfg.blipsEnabled then
		for k,v in ipairs(Cfg.Pacanele) do
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite(blip, 436)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 1.0)
			SetBlipColour(blip, 49)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Slot Machine")
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Check proximity to the slot machine and show interaction hint
CreateThread(function()
	open = false

	local wTime = 500
	local x = 1
	while true do
		Wait(wTime)
		langaAparat = false

		for i=1, #Cfg.Pacanele, 1 do
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Cfg.Pacanele[i].x, Cfg.Pacanele[i].y, Cfg.Pacanele[i].z, true) < 2 then
				
                x = i
				wTime = 0
				langaAparat = true
                if IsControlJustReleased(0, 38) and langaAparat then
                    -- TriggerServerEvent('esx_slotmachine:catiLeiBagi')
                    SetNuiFocus(true, true)
                end
				drawHint('Press ~INPUT_PICKUP~ to test your luck at the slot machine')
			elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Cfg.Pacanele[x].x, Cfg.Pacanele[x].y, Cfg.Pacanele[x].z, true) > 4 then
				wTime = 500
			end
		end
	end
end)

RegisterNetEvent("esx_slotmachine:openBettingDialog")
AddEventHandler("esx_slotmachine:openBettingDialog", function()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'bet_amount', {
        title = "How much you want to bet? (multiple of 50)"
    }, function(data, menu)
        local amount = tonumber(data.value)
        if amount then
            -- Send the amount back to the server for validation
            TriggerServerEvent('esx_slotmachine:processBet', amount)
        else
            ESX.ShowNotification("Invalid input")
            SetNuiFocus(false, false)
        end
        menu.close()
    end, function(data, menu)
        SetNuiFocus(false, false)
        menu.close()
    end)
end)

-- Event to handle opening the NUI slot machine with the bet amount
RegisterNetEvent('esx_slotmachine:bagXLei')
AddEventHandler('esx_slotmachine:bagXLei', function(amount)
	SetNuiFocus(true, true)
	open = true
	SendNUIMessage({
		showPacanele = "open",
		coinAmount = tonumber(amount)
	})
end)

-- Event triggered when the user exits the slot machine and sends the result

RegisterNUICallback('exitWith', function(data, cb)
	SetNuiFocus(false, false)
	open = false
    -- ESX.ShowNotification("Invalid input")
	TriggerServerEvent('esx_slotmachine:withdraw',data.coinAmount)
    if xPlayer then
        TriggerClientEvent("esx_slotmachine:closeSlotMachine", source)

    end
    cb('ok')
end)

RegisterNUICallback('enteringhud', function(data, cb)
    ESX.ShowNotification("Entering menu Slot")
    cb('ok')
end)
-- NUI Close Slot Machine Event
RegisterNetEvent('esx_slotmachine:closeSlotMachine')
AddEventHandler('esx_slotmachine:closeSlotMachine', function()
    SetNuiFocus(false, false) -- Disable the NUI focus
    SendNUIMessage({
        type = 'close' -- Trigger the client to close the NUI
    })
end)



-- Disable player controls while interacting with the slot machine
CreateThread(function()
	while true do
		Wait(1)
		if open then
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 24, true) -- Attack
			DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		elseif IsControlJustReleased(0, 38) and langaAparat then
			TriggerServerEvent('esx_slotmachine:catiLeiBagi')
        end
	end
end)







































-- original code
-- local isUIOpen = false



-- -- Opens the slot machine UI
-- local function openSlotMachineUI()
--     isUIOpen = true
--     SetNuiFocus(true, true)
--     SendNUIMessage({
--         action = 'open'
--     })
-- end

-- -- Closes the slot machine UI
-- local function closeSlotMachineUI()
--     isUIOpen = false
--     SetNuiFocus(false, false)
--     SendNUIMessage({
--         action = 'close'
--     })
-- end

-- -- Show UI when near slot machine
-- CreateThread(function()
--     while true do
--         local Sleep = 1500
--         local playerPed = PlayerPedId()
--         local playerCoords = GetEntityCoords(playerPed)
--         for _, location in pairs(Config.MachineLocations) do
--             local distance = #(playerCoords - location)
--             -- local dist = GetDistanceBetweenCoords(playerCoords, location.x, location.y, location.z, true)
--             print("Player coords:", playerCoords)
--                 print("Slot machine coords:", location)
--                 print("Distance to slot machine:", distance)
--             if distance < 10 then
--                 Sleep = 0
--                 DrawMarker(
--                     Config.MarkerType, 
--                     location.x, location.y, location.z,   -- Use x, y, z coordinates from location
--                     0.0, 0.0, 0.0,                       -- Direction (no rotation)
--                     0.0, 0.0, 0.0,                       -- Rotation
--                     Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, -- Size
--                     Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 
--                     100, false, true, 2, false, false, false, false
--                 )
--             end
--             if distance < 2 then
--                   ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to play the slot machine")
--                   if IsControlJustReleased(0, 38) then -- 'E' key
--                     openSlotMachineUI()
--                 end
--             end
--         end
--         Wait(Sleep)
--     end
-- end)

-- CreateThread(function()
-- 	for k,v in pairs(Config.MachineLocations) do
				
-- 			local blip = AddBlipForCoord(v)

--             SetBlipSprite(blip, 276)        -- Slot machine icon
--             SetBlipDisplay(blip, 4)         -- Show on both the map and minimap
--             SetBlipScale(blip, 1.0)         -- Blip size
--             SetBlipColour(blip, 5)          -- Purple color
--             SetBlipAsShortRange(blip, true) -- Only show the blip when nearby

-- 			BeginTextCommandSetBlipName('STRING')
-- 			AddTextComponentSubstringPlayerName('Slot Machine')
-- 			EndTextCommandSetBlipName(blip)
-- 	end
-- end)



-- -- Handle NUI callback when the player clicks the play button
-- RegisterNUICallback('play', function(data, cb)
--     closeSlotMachineUI() -- Close the UI
--     TriggerServerEvent('esx_slotmachine:play')
--     cb('ok')
-- end)

-- -- Receive the slot result from the server and send it to the NUI
-- RegisterNetEvent('esx_slotmachine:result')
-- AddEventHandler('esx_slotmachine:result', function(reel1, reel2, reel3)
--     SendNUIMessage({
--         reel1Symbol = reel1,
--         reel2Symbol = reel2,
--         reel3Symbol = reel3
--     })
-- end)
