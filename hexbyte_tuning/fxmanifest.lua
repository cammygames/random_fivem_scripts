fx_version 'cerulean'
game 'gta5'

description 'HexByte Tuning'
version '1.0.0'

shared_script 'config.lua'

client_script {
    'client/main.lua',
    'client/util.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'web/build/index.html',
    'web/build/asset-manifest.json',
    'web/build/**/*'
}

ui_page 'web/build/index.html'

lua54 'yes'

escrow_ignore {
	'web/**/*',
	'config.lua',
    'readme.md',
    'import.sql'
}