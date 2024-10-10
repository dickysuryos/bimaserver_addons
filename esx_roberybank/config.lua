Config = {}

Config.PoliceJob = 'police'  -- Job for police cover vehicles
Config.StockadeModel = 'stockade'  -- Model for the money truck
Config.MoneyBagItem = 'money_bag'  -- Item name for the money bag
Config.BagWeight = 20  -- Weight for the money bag

-- Spawn locations for Stockade
-- Config.StockadeLocations = {
--     {x = -132.4, y = -978.3, z = 29.2},
--     {x = 255.4, y = -372.8, z = 44.2},
--     {x = 1187.1, y = -330.8, z = 68.4},
-- }
Config.StockadeLocations = {
    vector3{x = -132.4, y = -978.3, z = 29.2},
}


-- Locations for ATMs where players need to deliver money
Config.ATMLocations = {
    {x = 147.12, y = -1035.67, z = 29.34},
    {x = -295.84, y = -204.09, z = 33.42},
    {x = -354.03, y = -53.41, z = 49.04},
}
