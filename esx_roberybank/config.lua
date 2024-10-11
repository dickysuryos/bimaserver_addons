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
    vector4(2823.6965, 1644.7046, 24.2412, 0.7014),
}

-- Locations for ATMs where players need to deliver money
Config.ATMLocations = {
    -- {x = 147.12, y = -1035.67, z = 29.34},
    vector4(149.91, -1040.74, 29.374, 160),
    vector4(-1212.63, -330.78, 37.59, 210),
    vector4(-2962.47, 482.93, 15.5, 270),
    vector4(-113.01, 6470.24, 31.43, 315),
    vector4(314.16, -279.09, 53.97, 160),
    vector4(-350.99, -49.99, 48.84, 160),
    vector4(1175.02, 2706.87, 37.89, 0),
    vector4(246.63, 223.62, 106.0, 160),
}
