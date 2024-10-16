--------------------------------------------------
-- 				Don't edit anything here		--
--					Made by Tazio				--
--------------------------------------------------


Cache = {}

-- Get balance of invested companies
RegisterServerEvent("invest:balance")
AddEventHandler("invest:balance", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local user = MySQL.query.await('SELECT `amount` FROM `invest` WHERE `identifier`= ? AND active=1', { xPlayer.getIdentifier()},function (user)
        return user
        
    end)
    local invested = 0
    for k, v in pairs(user) do
        -- print(k, v.identifier, v.amount, v.job)
        invested = math.floor(invested + v.amount)
    end
    TriggerClientEvent("invest:nui", _source, {
        type = "balance",
        player = xPlayer.getName(),
        balance = invested
    })
end)

-- Get available companies
RegisterServerEvent("invest:list")
AddEventHandler("invest:list", function()
    TriggerClientEvent("invest:nui", source, {
        type = "list",
        cache = Cache
    })
end)

-- Get all invested companies
RegisterServerEvent("invest:all")
AddEventHandler("invest:all", function(special)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local sql = 'SELECT `invest`.*, `companies`.`name`,`companies`.`investRate`,`companies`.`label` FROM `invest` '..
                'INNER JOIN `companies` ON `invest`.`job` = `companies`.`label` '..
                'WHERE `invest`.`identifier`= ?'

    if(special) then 
        sql = sql .. " AND `invest`.`active`=1"
    end

    local user = MySQL.query.await(sql, {xPlayer.getIdentifier()},function (user)
        return user
    end)

    -- for k, v in pairs(user) do
    --     print(k, v.identifier, v.amount, v.job, v.name, v.active, v.created, v.investRate)
    -- end

    if(special) then
        TriggerClientEvent("invest:nui", _source, {
            type = "sell",
            cache = user
        })
    else 
        TriggerClientEvent("invest:nui", _source, {
            type = "all",
            cache = user
        })
    end
end)

-- Invest into a job
RegisterServerEvent("invest:buy")
AddEventHandler("invest:buy", function(job, amount, rate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local bank = xPlayer.getAccount('bank').money
    local id = xPlayer.getIdentifier()
    amount = tonumber(amount)

    local inf = MySQL.query.await('SELECT * FROM `invest` WHERE `identifier`= ? AND active=1 AND job= ? LIMIT 1', {id, job},function (inf)
        return inf
    end)
    for k, v in pairs(inf) do inf = v end

    if(amount == nil or amount <= 0) then
        return TriggerClientEvent('esx:showNotification', _source, _U('invalid_amount'))
    elseif(Config.Stock.Limit ~= 0 and amount > Config.Stock.Limit) then
        return TriggerClientEvent('esx:showNotification', _source, string.gsub(_U('to_much'), "{limit}", format_int(Config.Stock.Limit)))
    else
        if(bank < amount) then
            return TriggerClientEvent('esx:showNotification', _source, _U('broke_amount'))
        end
        xPlayer.removeAccountMoney('bank', tonumber(amount))
    end

    if(type(inf) == "table" and inf.job ~= nil) then
        if Config.Debug then
            print("[esx_invest] Adding money to an existing investment")
        end

        MySQL.update("UPDATE invest SET amount=? WHERE identifier = ? AND active=1 AND job= ? ", {amount,xPlayer.getIdentifier(), job})
        
        TriggerClientEvent('esx:showNotification', _source, _U('added'))
    else
        if Config.Debug then
            print("[esx_invest] User new investment")
        end

        if rate == nil then
            return TriggerClientEvent('esx:showNotification', _source, _U('unexpected_error'))
        end

        MySQL.insert("INSERT INTO `invest` (identifier, job, amount, rate) VALUES (?,?,?,?)", {
            id,
            job,
            amount,
            rate
        })
        
        TriggerClientEvent('esx:showNotification', _source, _U('buy'))
    end

    TriggerEvent(_source, "invest:balance")
end)

-- Sell an investment
RegisterServerEvent("invest:sell")
AddEventHandler("invest:sell", function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local id = xPlayer.getIdentifier()

    local result = MySQL.query.await( 'SELECT `invest`.*, `companies`.`investRate` FROM `invest` '..
                                            'INNER JOIN `companies` ON `invest`.`job` = `companies`.`label` '..
                                            'WHERE `identifier`=? AND active=1 AND job=?', { id,job},function (result)
                         return result                       
     end)
    for k, v in pairs(result) do result = v end

    local amount = result.amount
    local sellRate = math.abs(result.investRate - result.rate)
    local addMoney = amount + ((amount * sellRate) / 100)

    
    -- print("intrest calc: " .. result.investRate .. " -> " .. result.rate .. " = " .. sellRate)
    -- print("money calc: " .. amount .. " -> " .. addMoney)

    MySQL.update("UPDATE  invest  SET active = 0, sold=now(), soldAmount = ?, rate = ?  WHERE id = ?", {addMoney,sellRate,result.id})

    if(addMoney > 0) then
        xPlayer.addAccountMoney('bank', addMoney)
    else
        addMoney = math.abs(addMoney)*-1
        xPlayer.removeAccountMoney('bank', addMoney)
    end
    
    TriggerClientEvent('esx:showNotification', _source, _U('sold'))
    TriggerEvent(_source, "invest:balance")
end)

-- Gives a random number
function genRand(min, max, decimalPlaces)
    local rand = math.random()*(max-min) + min;
    local power = math.pow(10, decimalPlaces);
    return math.floor(rand*power) / power;
end

-- Loop invest rates
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    function loopUpdate()
        Citizen.Wait(60000*Config.Stock.Time)

        if Config.Debug then
            print("[esx_invest] Creating new investments")
        end

        local companies = MySQL.query.await("SELECT * FROM `companies`",function (companies)
        end)
        for k, v in pairs(companies) do
            newRate = genRand(Config.Stock.Minimum, Config.Stock.Maximum, 2)

            local rate = "stale"
            if newRate > v.investRate then
                rate = "up"
            elseif newRate < v.investRate then
                rate = "down"
            end

            if(Config.Stock.Lost ~= 0 and newRate < 0) then
                local amount = Config.Stock.Lost/100*(100-Config.Stock.Lost)
                MySQL.query("UPDATE invest SET amount = ? WHERE active=1 AND job=?", {
                    Config.Stock.Lost,
                    v.label 
                })
            end

            
            MySQL.update("UPDATE companies SET investRate = ?,rate = ? WHERE label= ?", {
                newRate,
                rate,
                v.label,
            })
            Cache[v.label] = {stock = newRate, rate = rate, label = v.label, name = v.name}
        end
        loopUpdate()
    end

    Citizen.Wait(0) --Don't remove, crashes SQL

    if Config.Debug then
        print("[esx_invest] Powering Up")
    end

    local companies = MySQL.query.await("SELECT * FROM companies",function (companies)
        return companies
    end)
    for k, v in pairs(companies) do
        if(v.investRate == nil) then
            v.investRate = genRand(Config.Stock.Minimum, Config.Stock.Maximum, 2)
            MySQL.update("UPDATE companies SET investRate = ?  WHERE label=?", {
                v.investRate,
                v.label
            })
        end

        Cache[v.label] = {stock = v.investRate, rate = v.rate, label = v.label, name = v.name}
    end
    loopUpdate()
end)

function format_int(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

-- v1.2 >
-- print(genRand(0, 2, 2)) -- from 0.00 to 2.00
-- print(genRand(1, 2, 2)) -- from 1.00 to 2.00

-- v1.2 <
-- print(genRand(-5, 5, 2)) -- from -5% to 5%
-- print(math.abs(-1 - -2.95)) -- difference between -1% and -2.95%