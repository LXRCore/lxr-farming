fx_version "cerulean"

game 'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'LXR-Farming'
version '1.0.0'

shared_script 'config.lua'
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/client.lua'
}

server_script 'server/server.lua'

dependencie 'lxr-core'

lua54 'yes'