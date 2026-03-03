--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Farming System - RedM Resource Manifest

    ═══════════════════════════════════════════════════════════════════════════════
    RESOURCE INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Resource Name:  lxr-farming
    Version:        1.0.0
    Author:         iBoss21 / The Lux Empire
    Description:    Multi-framework farming system for RedM with configurable crop
                    zones, growth stages, and harvest mechanics.

    Server:         The Land of Wolves 🐺
    Website:        https://www.wolves.land
    Discord:        https://discord.gg/CrKcWdfd3A
    Store:          https://theluxempire.tebex.io

    ═══════════════════════════════════════════════════════════════════════════════
    FRAMEWORK SUPPORT
    ═══════════════════════════════════════════════════════════════════════════════

    Primary:
    - LXR Core (lxr-core)
    - RSG Core (rsg-core)

    Supported:
    - VORP Core (vorp_core)

    Optional (if detected):
    - RedEM:RP (redem_roleplay)
    - QBR Core (qbr-core)
    - QR Core (qr-core)
    - Standalone (no framework)

    ═══════════════════════════════════════════════════════════════════════════════

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

fx_version 'cerulean'
game 'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

-- Resource Metadata
name        'LXR Farming System'
author      'iBoss21 / The Lux Empire'
description 'Multi-framework farming system with configurable crop zones, growth stages, and harvest mechanics'
version     '1.0.0'

-- Lua 5.4
lua54 'yes'

-- Shared Scripts (loaded on both client and server)
shared_script 'config.lua'

-- Client Scripts
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/client.lua'
}

-- Server Scripts
server_script 'server/server.lua'

-- Dependencies (soft — framework detection handled at runtime)
dependencies {
    '/onesync',
}