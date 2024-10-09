fx_version 'adamant'
game 'gta5'

author 'Terranova'
description 'ESX Lottery Script'
lua54 'yes'
version '1.0.0'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server/main.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'client/main.lua'
}

dependencies {
    'es_extended'
}
