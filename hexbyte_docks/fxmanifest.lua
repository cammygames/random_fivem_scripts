fx_version 'cerulean'
game 'gta5'

description 'HexByte Docks'
version '0.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    '@qb-core/shared/locale.lua',
	'locales/en.lua',
	'locales/*.lua',
    'config.lua',
}

client_scripts {
    'client/*.lua',
    'editable/client/*.lua',
}

server_scripts {
    'server/*.lua',
    'editable/server/*.lua',
}

dependencies { 
    'qb-core', 
    'qb-target', 
    'qb-menu'
}

escrow_ignore {
    'config.lua',
	'locales/*.lua',
	'editable/*/*.lua',
}

lua54 'yes'
