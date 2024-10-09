
RegisterServerEvent("esx_slotmachine:catiLeiBagi")
AddEventHandler("esx_slotmachine:catiLeiBagi", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        -- Trigger a client event to ask for input
        TriggerClientEvent("esx_slotmachine:openBettingDialog", source)
    end
end)

-- Event triggered when a player wins or loses
RegisterServerEvent("esx_slotmachine:aiCastigat")
AddEventHandler("esx_slotmachine:aiCastigat", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        amount = tonumber(amount)
        if amount and amount > 0 then
            xPlayer.addMoney(amount)
            TriggerClientEvent("chatMessage", source, "^1Slots^7: You won ^2$"..amount.."^7 not bad at all!")
        else
            TriggerClientEvent("chatMessage", source, "^1Slots^7: Unfortunately you've ^1lost ^7all the money, maybe next time.")
        end
    end
end)

RegisterServerEvent('esx_slotmachine:processBet')
AddEventHandler('esx_slotmachine:processBet', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    amount = tonumber(amount)
    if amount and amount % 50 == 0 and amount >= 50 then
        if xPlayer.getMoney() >= amount then
            xPlayer.removeMoney(amount,"betting".." "..amount)
            TriggerClientEvent('esx:showNotification', source, "~r~Berhasil Deposit")
            TriggerClientEvent('esx_slotmachine:bagXLei',source,amount)
        else
            TriggerClientEvent('esx:showNotification', source, "~r~Not enough money")
            TriggerClientEvent("esx_slotmachine:closeSlotMachine")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "You must insert a multiple of 50. ~n~~y~Example: 100, 350, 2500")
        TriggerClientEvent("esx_slotmachine:openBettingDialog", source)
    end
end)

RegisterServerEvent("esx_slotmachine:withdraw")
AddEventHandler("esx_slotmachine:withdraw",function (amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    amount = tonumber(amount)
    if xPlayer then
        xPlayer.addMoney(amount)
        TriggerClientEvent('esx:showNotification', source, "~g~Berhasil Withdraw".." "..amount.." ")
    end
end)





























-- original code
-- RegisterServerEvent('esx_slotmachine:play')
-- AddEventHandler('esx_slotmachine:play', function()
--     local _source = source
--     local xPlayer = ESX.GetPlayerFromId(_source)
    
--     local bet = 500
--     local payout = 0
--     local reel1, reel2, reel3 = getRandomSymbols()

--     if xPlayer.getMoney() >= bet then
--         xPlayer.removeMoney(bet)

--         if reel1 == reel2 and reel2 == reel3 then
--             payout = Config.Payouts[reel1] or 0
--             xPlayer.addMoney(payout)
--             TriggerClientEvent('esx:showNotification', _source, 'You won $' .. payout)
--         else
--             TriggerClientEvent('esx:showNotification', _source, 'Better luck next time!')
--         end

--         -- Send the result back to the client
--         TriggerClientEvent('esx_slotmachine:result', _source, reel1, reel2, reel3)
--     else
--         TriggerClientEvent('esx:showNotification', _source, 'Not enough money!')
--     end
-- end)

-- function getRandomSymbols()
--     local symbols = { 'CHERRY', 'BELL', 'BAR', '777' }
    
--     local rand1 = symbols[math.random(#symbols)]
--     local rand2 = symbols[math.random(#symbols)]
--     local rand3 = symbols[math.random(#symbols)]
    
--     return rand1, rand2, rand3
-- end
