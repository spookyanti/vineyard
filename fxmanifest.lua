fx_version "adamant"
game "gta5"
lua54 "yes"


author "SPF Scripts"
description "GTA inspired casino heist"
version "0.0.1"


shared_scripts{
    "@ox_lib/init.lua",
    "config.lua"
}

files{
    "locales/*.json"
}

client_scripts{
    "client/edit.lua",
    "client/main.lua"
}

server_scripts{
    "server/edit.lua",
    "server/main.lua"
}

depency "ox_lib"