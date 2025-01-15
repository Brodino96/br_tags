fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "Brodino"
version "1.2"
description "Tag, you're it!"

shared_scripts { "@ox_lib/init.lua", "config.lua", }
server_scripts { "@oxmysql/lib/MySQL.lua", "server/*", }
client_scripts { "client/*", }

files { "web/*", }
ui_page "web/index.html"

dependencies { "ox_lib", "es_extended", "oxmysql" }