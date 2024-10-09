
-- Generate a random 4-digit number
local function generateRandomTicketNumber()
    return math.random(10, 99)
end
local name = ""
local hadiah = 0
local winner = false
local lastPurchaseTime = {}
-- Save purchased ticket to the database
RegisterServerEvent('esx_lotre:buyTicket')
AddEventHandler('esx_lotre:buyTicket', function(ticketNumber,amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local total = 1000 * amount
    local identifier = xPlayer.getIdentifier()
    xPlayer.removeMoney(total,"Beli Nomer Togel")
    Wait(500)
    -- Add cooldown for the player
        if lastPurchaseTime[identifier] and (os.time() - lastPurchaseTime[identifier]) < 5 then
            TriggerClientEvent('esx:showNotification', source, "Please wait before buying another ticket.")
            return
        end
        lastPurchaseTime[identifier] = os.time()
        MySQL.query('SELECT * FROM announced_tickets WHERE status = 1',function (tickets)
            if #tickets > 0 then
                for _, ticket in ipairs(tickets) do
                if ticket.ticket_number == ticketNumber then
                    print(ticket.ticket_number)
                    local reward = 1000000 * amount
                    winer = true
                    
                    xPlayer.addMoney(reward)
                    MySQL.insert('INSERT INTO announced_tickets (ticket_number,status) VALUES (?,?)',{
                        tonumber(generateRandomTicketNumber()),1
                    },function ()
                        MySQL.update('UPDATE announced_tickets SET status = 0, winner = ? WHERE id = ?',{
                            xPlayer.name,
                            tonumber(ticket.id)
                            },function ()
                                name = xPlayer.name
                                hadiah = reward
                                winner = true
                                -- TriggerClientEvent('esx:notifAllPlayer',11,"dheo")
                                TriggerClientEvent('esx:showNotification',-1,""..name.." ".."Memenangkan Tiket Lotre sebesar Rp."..reward.."")
                                -- xPlayer.showNotification(xPlayer.name.." ".."Memenangkan Tiket Lotre sebesar Rp."..reward.."")
                               
                            end
                        )
                    end)  
                else 
                    xPlayer.showNotification('Anda Kurang Beruntung Silakan Coba Lagi')
                    end
                end
                print('tiket null')
            end
        end
    )

      -- Remove the oldest ticket if more than 5 records exist
      MySQL.query('SELECT id FROM announced_tickets ORDER BY announce_time ASC', {}, function(tickets)
        if #tickets > 5 then
            local oldestTicketId = tickets[1].id
            MySQL.query('DELETE FROM announced_tickets WHERE id = ?', { oldestTicketId })
        end
    end)
end)

-- -- ESX callback to get announced tickets for the ESX phone
ESX.RegisterServerCallback('esx_lotre:getAnnouncedTickets', function(source, cb)
    
    local response = MySQL.query.await('SELECT * FROM announced_tickets WHERE status = 0 ORDER BY announce_time DESC')
    local formattedTickets = {}
        for i=1, #response, 1 do
            table.insert(formattedTickets, {
                ticket_number = response[i].ticket_number,
                announce_time = os.date('%d-%m-%Y %H:%M:%S',response[i].announce_time)
            })
        end
        cb(formattedTickets)
       
      
end)

ESX.RegisterServerCallback('esx_lotre:getForPhone', function(source, cb)
    
    local response = MySQL.query.await('SELECT * FROM announced_tickets WHERE status = 0 ORDER BY announce_time DESC')
    local formattedTickets = {}
    if #response > 0 then
        for i=1, #response, 1 do
            table.insert(formattedTickets, {
                ticket_number = response[i].ticket_number,
                winner = response[i].winner
            })
        end
        cb(formattedTickets)
    end
    cb(formattedTickets)
       
      
end)


-- CreateThread(function ()
--     while true do
--         Citizen.Wait(0)
--         if winner == true then 
--         TriggerClientEvent('esx:showNotification',-1,"".. name.."Memenangkan Tiket Lotre sebesar Rp."..hadiah.."")
--         winner = false
--         hadiah = 0
--         name = ""
--         end
--     end
-- end)