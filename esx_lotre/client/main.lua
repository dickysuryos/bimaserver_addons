RegisterNetEvent('esx_lotre:openMenu')
AddEventHandler('esx_lotre:openMenu', function(amount)
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lottery_menu', {
    title    = 'Lottery',
    align    = 'center',
    elements = {
      {label = 'Buy Ticket ($'..amount * 1000 ..')', value = 'buy_ticket'},
      {label = 'View Announced Tickets', value = 'view_announced'}
    }
  }, function(data, menu)
    if data.current.value == 'buy_ticket' then
      ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'buy_ticket',
        {
            title = "Enter your lottery number (2 digits)"
        },
        function(data, menu)
            local ticketNumber = tonumber(data.value)
            if ticketNumber and ticketNumber >= 10 and ticketNumber <= 99 then
                TriggerServerEvent('esx_lotre:buyTicket', ticketNumber,amount)
                -- ESX.ShowNotification("You've bought a lottery ticket with number: " .. ticketNumber)
            else
                ESX.ShowNotification("Pastikan angka di atas 10 dan 2 digit !")
            end
            menu.close()
          end, function(data, menu)
            menu.close()
          end)
    elseif data.current.value == 'view_announced' then
      ESX.TriggerServerCallback('esx_lotre:getAnnouncedTickets', function(tickets)
        -- Display the announced tickets (can use ESX.ShowNotification or a custom NUI/phone app)
        for _, ticket in ipairs(tickets) do
          ESX.ShowNotification(('Ticket: ~g~%s~s~ announced at ~y~%s~s~'):format(ticket.ticket_number, ticket.announce_time))
        end
      end)
    end
    menu.close()
  end, function(data, menu)
    menu.close()
  end)
end)

-- CreateThread(function ()
--   local source = source
--   TriggerServerEvent('esx_lotre:updateInventory',source)
-- end)

RegisterNetEvent('esx_lotre:notifAllPlayer')
AddEventHandler('esx_lotre:notifAllPlayer',function (name)
  ESX.ShowNotification(""..name.."Memenangkan Tiket Lotre sebesar Rp."..reward.."")
end)

RegisterNetEvent('esx_lotre:notifNotGetReward')
AddEventHandler('esx_lotre:notifNotGetReward',function (source)
  ESX.UI.Menu.Open('default', source, 'lottery_menu', {
    title    = 'Lottery',
    align    = 'center',
    elements = {
      {label = 'Anda Kurang Beruntung Silakan Coba Lagi', value = 'buy_ticket'}
    }
  }, function(data, menu)
    menu.close()
  end)
end)

-- Client-side code (esx_lotre/client/main.lua or another relevant file)
RegisterNetEvent('esx_lotre:playJackpotSound')
AddEventHandler('esx_lotre:playJackpotSound', function()
    -- Play the jackpot sound (use one of the native sound names or choose your own)
    PlaySoundFrontend(-1, "WINNER", "HUD_AWARDS", true) -- Example sound
end)
-- RegisterNetEvent('esx_lotre:sendNotif')
-- AddEventHandler('esx_lotre:sendNotif', function(number,message)
--   TriggerServerEvent('esx_phone:send', number, message, true, {
--     x = 0,
--     y = 0,
--     z = 0
-- })
-- end)