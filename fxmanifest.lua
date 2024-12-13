fx_version "cerulean"
games { "gta5" }
lua54 "yes"

shared_scripts { "@ox_lib/init.lua", "shared.lua", }
server_scripts { "@oxmysql/lib/MySQL.lua", "server.lua", }
client_scripts { "client.lua", }

dependencies { "ox_lib", "es_extended" }