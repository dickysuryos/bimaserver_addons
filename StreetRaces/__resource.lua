resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

shared_script '@es_extended/imports.lua'
server_scripts {
    "config.lua",
    "port_sv.lua",
    "races_sv.lua",
    '@es_extended/locale.lua',
    '@es_extended/locale.lua',
}

shared_script '@es_extended/imports.lua'


client_scripts {
    '@es_extended/locale.lua',
    "config.lua",
    "races_cl.lua",
}
