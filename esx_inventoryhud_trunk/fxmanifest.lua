fx_version "adamant"
game "gta5"

author "Trsak"

description "ESX trunk inventory"

version "2.4.0"
shared_script '@es_extended/imports.lua'
server_scripts {
  "@mysql-async/lib/MySQL.lua",
  "@es_extended/locale.lua",
  "locales/*.lua",
  "config.lua",
  "server/classes/c_trunk.lua",
  "server/trunk.lua",
  "server/esx_trunk-sv.lua"
}

client_scripts {
  "@es_extended/locale.lua",
  "locales/*.lua",
  "config.lua",
  "client/esx_trunk-cl.lua"
}

dependencies {
  'es_extended'
}