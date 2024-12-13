fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "Brodino"
version "1.0"
description "Tag, you're it!"

shared_scripts { "@ox_lib/init.lua", "shared.lua", }
server_scripts { "@oxmysql/lib/MySQL.lua", "server/*", }
client_scripts { "client.lua", }

dependencies { "ox_lib", "es_extended" }