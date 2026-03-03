--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Core - Farming System

    This configuration file controls the farming system for RedM.
    Players can plant seeds, tend crops, and harvest them for items once grown.
    Each zone, crop type, and growth timer is fully configurable below.

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted

    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb

    ═══════════════════════════════════════════════════════════════════════════════

    Version: 1.0.0
    Performance Target: Optimized for minimal server overhead and client FPS impact

    Tags: RedM, Georgian, SeriousRP, Whitelist, Farming, Economy, Survival

    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Compatible)
    - VORP Core (Compatible)
    - RedEM:RP (Compatible)
    - QBR Core (Compatible)
    - QR Core (Compatible)
    - Standalone (Compatible)

    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════

    Script Author: iBoss21 / The Lux Empire for The Land of Wolves

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-farming"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[

        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════

        Expected: %s
        Got: %s

        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.

        🐺 wolves.land - The Land of Wolves

        ═══════════════════════════════════════════════════════════════════════════════

    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name        = 'The Land of Wolves 🐺',
    tagline     = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type        = 'Serious Hardcore Roleplay',
    access      = 'Discord & Whitelisted',

    -- Contact & Links
    website       = 'https://www.wolves.land',
    discord       = 'https://discord.gg/CrKcWdfd3A',
    github        = 'https://github.com/iBoss21',
    store         = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',

    -- Developer Info
    developer = 'iBoss21 / The Lux Empire',

    -- Tags
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'Farming', 'Economy', 'Survival'}
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core  (Primary)
    2. RSG-Core  (Primary)
    3. VORP Core (Supported)
    4. RedEM:RP  (Optional - if detected)
    5. QBR-Core  (Optional - if detected)
    6. QR-Core   (Optional - if detected)
    7. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' or manual: 'lxr-core', 'rsg-core', 'vorp_core', 'redem_roleplay', 'qbr-core', 'qr-core', 'standalone'

-- Framework-specific settings
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource     = 'lxr-core',
        notifications = 'ox_lib',
        inventory    = 'lxr-inventory',
        target       = 'ox_target',
        events = {
            server   = 'lxr-farming:server:%s',
            client   = 'lxr-farming:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    ['rsg-core'] = {
        resource      = 'rsg-core',
        notifications = 'ox_lib',
        inventory     = 'rsg-inventory',
        target        = 'ox_target',
        events = {
            server   = 'RSGCore:Server:%s',
            client   = 'RSGCore:Client:%s',
            callback = 'RSGCore:Callback:%s'
        }
    },
    ['vorp_core'] = {
        resource      = 'vorp_core',
        notifications = 'vorp',
        inventory     = 'vorp_inventory',
        target        = 'vorp_core',
        events = {
            server = 'vorp:server:%s',
            client = 'vorp:client:%s'
        }
    },
    ['redem_roleplay'] = {
        resource      = 'redem_roleplay',
        notifications = 'redem',
        inventory     = 'redem_inventory',
        target        = 'redem_target',
        events = {
            server = 'redem:%s:server',
            client = 'redem:%s:client'
        }
    },
    ['qbr-core'] = {
        resource      = 'qbr-core',
        notifications = 'ox_lib',
        inventory     = 'qbr-inventory',
        target        = 'ox_target',
        events = {
            server = 'QBR:Server:%s',
            client = 'QBR:Client:%s'
        }
    },
    ['qr-core'] = {
        resource      = 'qr-core',
        notifications = 'ox_lib',
        inventory     = 'qr-inventory',
        target        = 'ox_target',
        events = {
            server = 'QR:Server:%s',
            client = 'QR:Client:%s'
        }
    },
    ['standalone'] = {
        notifications = 'print',
        inventory     = 'none',
        target        = 'none'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'en' -- Language for notifications (en, ge, etc.)

Config.Locale = {
    en = {
        pick_crop      = 'Pick Crop',
        planting       = 'Planting seed...',
        harvesting     = 'Harvesting crop...',
        crop_picked    = 'You harvested a crop!',
        seed_planted   = 'Seed planted successfully.',
        not_in_zone    = 'You must be in a farming zone.',
        no_seed        = 'You do not have a valid seed.'
    },
    ge = {
        pick_crop      = 'მოსავლის აღება',
        planting       = 'თესვა...',
        harvesting     = 'მოსავლის აღება...',
        crop_picked    = 'მოსავალი აღებულია!',
        seed_planted   = 'თესლი დარგულია.',
        not_in_zone    = 'სასოფლო-სამეურნეო ზონაში უნდა იყო.',
        no_seed        = 'სათანადო თესლი არ გაქვს.'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SETTINGS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Ticker = 20    -- Growth tick interval in minutes (crops advance one stage every N minutes)
Config.Debug  = false -- Enable debug prints and zone outlines

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FARMING ZONES ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Blips list: https://github.com/femga/rdr3_discoveries/tree/3f8917d8b581736548387d3296aa6288b5168869/useful_info_from_rpfs/textures/blips
Config.FarmingZones = {
    [1] = {
        blip   = 669307703, -- Remove or set to false to disable the map blip
        coords = vector4(1701.36, -1460.74, 47.86, 110.0),
        dim    = vector2(50.0, 100.0)
    },
    [2] = {
        coords = vector4(1136.83, 457.08, 96.84, 130.79), -- Farm House
        dim    = vector2(70.0, 50.0)
    },
    [3] = {
        coords = vector4(1802.88, -1468.22, 45.40, 116.95), -- Farm House
        dim    = vector2(100.0, 30.0)
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CROP CONFIGURATION ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Maps world prop model hashes to the item name given when the crop is harvested.
-- Seed items must be named  seed_<item>  (e.g. seed_american_ginseng).
Config.FarmingCrops = {
    [`ginseng_p`]             = 'american_ginseng',
    [`alaskanginseng_p`]      = 'alaskan_ginseng',
    [`blackcurrant_p`]        = 'black_currant',
    [`s_inv_huckleberry01x`]  = 'huckle_berry',
    [`s_inv_blackberry01x`]   = 'black_berry',
    [`s_inv_baybolete01bx`]   = 'bay_bolete',
    [`wildmint_p`]            = 'mint',
    [`s_indiantobacco01x`]    = 'tobacco',
    [`crp_cornstalks_bc_sim`] = 'corn',
    [`indtobacco_p`]          = 'coffee'
}
