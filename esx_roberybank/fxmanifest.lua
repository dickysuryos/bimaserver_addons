fx_version 'adamant'

game 'gta5'

description 'robbery the bank'
lua54 'yes'
version '1.0.2'
legacyversion '1.9.1'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'server/*.lua'
}

client_scripts {
	'config.lua',
	'client/*.lua'
}

dependencies {
	'es_extended',
}
