--[[
    ██╗     ██╗  ██╗██████╗       ███████╗ █████╗ ██████╗ ███╗   ███╗██╗███╗   ██╗ ██████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔══██╗██╔══██╗████╗ ████║██║████╗  ██║██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗█████╗  ███████║██████╔╝██╔████╔██║██║██╔██╗ ██║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══╝  ██╔══██║██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝

    LXR Core - Farming

    Ground broken with a hoe, seed from a paper packet, water from a bucket,
    and time. Plants live on the server (they survive restarts), grow through
    three stages, wither if nobody comes for them, and stop in winter. What
    comes out of the ground is the core catalog's own produce, sold on the
    same shelves as everything else.

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Product:     wolves.land / The Land of Wolves
    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/GAhk8cgXe9
    GitHub:      https://github.com/LXRCore

    Version: 3.0.0
    Performance Target: 0.00 ms idle (one 60 s growth tick on the server; a 2 s range loop on the client)

    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

Config = Config or {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE ██████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
Config.Lang = 'en'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CROPS ═════════════════════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
-- seed and yield are core catalog items. minutes is real time per stage
-- (seedling → growing → ripe); an unwatered stage takes `dryFactor` times as long.
-- props: corn and tobacco were in use on the previous build; the rest are
-- best guesses — a model that fails IsModelValid is skipped and the plant is
-- still marked by its prompt, so a wrong name never breaks the field.
Config.Crops = {
    corn       = { seed = 'seed_corn',       yield = { item = 'corn',         min = 4, max = 8 },  minutes = 40, props = { 'crp_cornstalks_bc_sim', 'crp_cornstalks_bc_sim', 'crp_cornstalks_bc_sim' } },
    potato     = { seed = 'seed_potato',     yield = { item = 'potato',       min = 3, max = 7 },  minutes = 35, props = { 's_inv_wildcarrot01x', 's_inv_wildcarrot01x', 's_inv_wildcarrot01x' } },
    carrot     = { seed = 'seed_carrot',     yield = { item = 'carrot',       min = 4, max = 9 },  minutes = 30, props = { 's_inv_wildcarrot01x', 's_inv_wildcarrot01x', 's_inv_wildcarrot01x' } },
    tomato     = { seed = 'seed_tomato',     yield = { item = 'tomato',       min = 3, max = 6 },  minutes = 35, props = { 's_indiantobacco01x', 's_indiantobacco01x', 's_indiantobacco01x' } },
    tobacco    = { seed = 'seed_tobacco',    yield = { item = 'tobacco_leaf', min = 4, max = 10 }, minutes = 50, props = { 's_indiantobacco01x', 's_indiantobacco01x', 's_indiantobacco01x' } },
    sugar_beet = { seed = 'seed_sugar_beet', yield = { item = 'sugar_beet',   min = 3, max = 6 },  minutes = 45, props = { 's_inv_wildcarrot01x', 's_inv_wildcarrot01x', 's_inv_wildcarrot01x' } },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FIELDS ════════════════════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
Config.Fields = {
    anywhere = false,             -- true: plant anywhere outside the towns below; false: only in the fields listed
    list = {
        { id = 'caliga',   label = 'Caliga Hall fields',   coords = vector3(1701.36, -1460.74, 47.86), radius = 70.0, blip = true },
        { id = 'emerald',  label = 'Emerald Ranch fields', coords = vector3(1136.83, 457.08, 96.84),   radius = 60.0, blip = true },
        { id = 'braith',   label = 'Braithwaite fields',   coords = vector3(1802.88, -1468.22, 45.40), radius = 70.0, blip = true },
    },
    towns = {                     -- no planting within these radii when `anywhere` is on
        { coords = vector3(-300.0, 790.0, 118.0), radius = 220.0 },   -- Valentine
        { coords = vector3(1330.0, -1300.0, 77.0), radius = 200.0 },  -- Rhodes
        { coords = vector3(2640.0, -1220.0, 53.0), radius = 400.0 },  -- Saint Denis
        { coords = vector3(-820.0, -1320.0, 43.0), radius = 220.0 },  -- Blackwater
        { coords = vector3(-3660.0, -2620.0, -13.0), radius = 200.0 }, -- Armadillo
        { coords = vector3(-5500.0, -2940.0, -2.0), radius = 200.0 },  -- Tumbleweed
        { coords = vector3(-1800.0, -390.0, 160.0), radius = 150.0 },  -- Strawberry
    },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GROWTH ════════════════════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
Config.Growth = {
    dryFactor = 2.0,              -- an unwatered stage takes this many times longer
    witherMinutes = 180,          -- ripe and unharvested this long: the plant dies
    winterGrows = false,          -- lxr-weather season 'winter' halts growth (plants still live)
    tickSeconds = 60,
}

Config.Limits = { perPlayer = 12, perField = 80, spacing = 1.5, anyoneHarvests = false, lawPulls = true }
Config.Tools = { plant = 'hoe', water = 'bucket' }
Config.Work = { plantMs = 4000, waterMs = 3000, harvestMs = 4000, scenario = 'WORLD_HUMAN_CROUCH_INSPECT' }
Config.Security = { rateLimit = { windowMs = 2000, burst = 6 }, maxDistance = 3.0, promptDistance = 2.0, propRange = 120.0 }
Config.Debug = { printBanner = true, log = true }
