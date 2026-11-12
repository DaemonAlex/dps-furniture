fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'DelPerroSands'
description 'Puts the streamed furniture packs into the qs-housing furniture shop. Reads the studio photo table at boot and registers every piece that has a picture through qs-housing AddFurniture (the same door Killstorex uses). Nothing is written into qs-housing.'
version '1.0.0'

dependencies {
    'oxmysql',
    'qs-housing',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'data/models.lua',
    'server.lua',
}
