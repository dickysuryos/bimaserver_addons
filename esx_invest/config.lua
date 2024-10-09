Config = {}

-- Language
Config.Locale = 'en'

-- Blips
Config.BlipCoords = {
    {x=-692.28, y=-587.52, z=31.55},
    {x=243.27, y=-1072.81, z=29.29},
    {x=-840.45, y=-334.11, z=38.68},
}
Config.BlipName = "Stock Exchange"
Config.BlipID = 374
Config.BlipActive = true

-- Open & close key
Config.Keys = {
    Open = "E",
    Close = "ESC"
}


-- Stock settings
-- min/max is in %
-- time is in minutes
-- limit is in $ (0 = no limit)
-- lost is in % (0 = no lost of money)
Config.Stock = {
    Minimum = -50,
    Maximum = 50,
    Time = 1,
    Limit =10000000,
    Lost = 60
}

-- Documentation:
-- Min/Max is the min/max all the stocks can go
-- Time is the time the new rates will be given
-- Limit is the maximum amount that can be invest into a company
-- Lost is the % that will be lost when a stock is at a negative %

-- Debug mode
Config.Debug = false