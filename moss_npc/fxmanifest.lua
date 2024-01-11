fx_version "cerulean"
game "gta5"

description 'moss_npc'
version '0.0.1'

shared_scripts {
	"@ox_lib/init.lua",
	"config.lua"
}

client_scripts {
    "modules/**/client/*.lua",
    "modules/**/client.lua"
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
    "modules/**/server/*.lua",
    "modules/**/server.lua"
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'qbx_core',
}

lua54 'yes'