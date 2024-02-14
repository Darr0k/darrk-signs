fx_version 'cerulean'
game 'gta5'
author "darr_k"
this_is_map 'yes'
version '1.0.0'

client_script 'client/*.lua'
server_script 'server/*.lua'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

ui_page 'html/index.html'
files {
    "signs.json",
    "html/**",
    'stream/**.ytyp',
}

dependencies {
    "ox_lib",
    "qb-core",
    "qb-target"
}

data_file 'DLC_ITYP_REQUEST' 'stream/prop_minecraft_sign.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_floor_sign.ytyp'

lua54 'yes'