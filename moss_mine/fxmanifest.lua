fx_version "cerulean"
game "gta5"

description 'moss_mine'
version '0.0.1'

shared_scripts {
	"@ox_lib/init.lua",
	"config.lua"
}

client_scripts {
    "@PolyZone/client.lua",
    '@PolyZone/CircleZone.lua',
    "client/*.lua",
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
    "server/*.lua"
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'qbx_core',
}

lua54 'yes'