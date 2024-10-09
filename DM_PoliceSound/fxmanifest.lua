fx_version 'adamant'

game 'gta5'

description 'ESX MEGA PHONE'

version '1.1.0'

client_scripts {
    'Resources/cl.lua',
    'Resources/config.lua'
}
server_scripts {
    'Resources/sv.lua',
    'Resources/config.lua'
}
shared_scripts {
    'Resources/config.lua',
    '@es_extended/imports.lua'
} 

auther '^Dm#0147'

ui_page 'html/index.html'

files {
    'html/sounds/*.ogg',
    'html/index.html'
}
dependency 'es_extended'