function GetItemFromShop(itemName, zone)
	local zoneItems = Config.Zones[zone].Items
	local item = nil

	for _, itemData in pairs(zoneItems) do
		if itemData.name == itemName then
			item = itemData
			break
		end
	end

	if not item then
		return false
	end

	return true,item.price, item.label
end

RegisterServerEvent('esx_shops:buyItem')
AddEventHandler('esx_shops:buyItem', function(itemName, amount, zone)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local Exists, price, label = GetItemFromShop(itemName, zone)
	amount = ESX.Math.Round(amount)
	print(amount)
	print(price)
	price = price * amount
	print(price)
	if xPlayer.getMoney() < price then 
		ESX.ShowNotification("Uang mu tidak cukup nak !.")
		return 
	end
	if label == 'Togel(lottery)' then
		if xPlayer.getMoney() >= price then 
			print(('[^3WARNING^7] Player ^5%s^7 Beli Lotre ya lu!'):format(source))
        
			TriggerClientEvent('esx_lotre:openMenu', source, amount)
			return
		 else 
			ESX.ShowNotification("Uang mu tidak cukup untuk berjudi nak !.")
			return
		 end
		
    end

	if amount < 0 then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to exploit the shop!'):format(source))
		return
	end

	if not Exists then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to exploit the shop!'):format(source))
		return
	end

	if Exists then
		-- can the player afford this item?
		if xPlayer.getMoney() >= price then
			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, amount) then
				xPlayer.removeMoney(price, label .. " " .. TranslateCap('purchase'))
				xPlayer.addInventoryItem(itemName, amount)
				xPlayer.showNotification(TranslateCap('bought', amount, label, ESX.Math.GroupDigits(price)))
			else
				xPlayer.showNotification(TranslateCap('player_cannot_hold'))
			end
		else
			local missingMoney = price - xPlayer.getMoney()
			xPlayer.showNotification(TranslateCap('not_enough', ESX.Math.GroupDigits(missingMoney)))
		end
	end
end)
