fx_version 'adamant'
game 'gta5'

author 'SlotTerra'
description 'ESX Slot Machine with Custom UI and OxMySQL'
lua54 'yes'
version '1.0'
legacyversion '1.9.1'


shared_scripts { 
    '@es_extended/imports.lua',
    '@es_extended/locale.lua', 
    'config.lua',
}

-- Client and server scripts
client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- This replaces the old MySQL-Async
    'server/main.lua'
}

-- NUI files
files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/img/*.png',
    'html/audio/*.wav'
}

ui_page 'html/index.html'



-- ESX dependency
dependency {
'es_extended',
'oxmysql'
}


