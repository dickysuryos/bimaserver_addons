resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Speedcamera'

version '0.0.1'

shared_script '@es_extended/imports.lua'

server_scripts {
  'server/main.lua'
}

client_scripts {
  'client/main.lua'
}

ui_page('html/index.html')

files {
    'html/index.html'
}
dependencies {
  'es_extended',
}