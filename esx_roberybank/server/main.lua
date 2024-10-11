
local moneyBags = {}

-- Callback for giving the player a money bag
ESX.RegisterServerCallback('esx_robbery:giveMoneyBag', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem(Config.MoneyBagItem, 1) then
        xPlayer.addInventoryItem(Config.MoneyBagItem, 1)
        table.insert(moneyBags, source)  -- Track players with money bags
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('esx_robbery:completeStockadeRobbery')
AddEventHandler('esx_robbery:completeStockadeRobbery', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Add your reward logic here
    xPlayer.addInventoryItem('money_bag', 1)
    TriggerClientEvent('esx:showNotification', source, "You've successfully robbed the Stockade!")
end)

-- Load the money bag into a vehicle or inventory
RegisterServerEvent('esx_robbery:loadMoneyBag')
AddEventHandler('esx_robbery:loadMoneyBag', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(Config.MoneyBagItem, 1)
    TriggerClientEvent('esx:showNotification', source, 'You have loaded the money bag!')
end)

-- Handle ATM delivery and rewards
RegisterServerEvent('esx_robbery:deliverMoneyBag')
AddEventHandler('esx_robbery:deliverMoneyBag', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem(Config.MoneyBagItem).count > 0 then
        xPlayer.removeInventoryItem(Config.MoneyBagItem, 1)
        xPlayer.addMoney(math.random(10000, 20000))  -- Random payout
        TriggerClientEvent('esx:showNotification', source, 'You have successfully delivered the money!')
    else
        TriggerClientEvent('esx:showNotification', source, 'You don\'t have a money bag!')
    end
end)
