--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Farming System — Server

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Server:    The Land of Wolves 🐺
    Developer: iBoss21 / The Lux Empire
    Website:   https://www.wolves.land
    Discord:   https://discord.gg/CrKcWdfd3A
    Store:     https://theluxempire.tebex.io

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
    ═══════════════════════════════════════════════════════════════════════════════
]]

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK BRIDGE ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Auto-detects the active framework and returns a unified interface:
      Bridge.GetPlayer(src)           -> player object (or nil)
      Bridge.AddItem(player, item, count, slot) -> boolean
      Bridge.RemoveItem(player, item, count, slot) -> boolean
      Bridge.RegisterUsableItem(name, cb)
]]

local _framework = nil

local function DetectFramework()
    local cfg = Config.Framework

    -- Manual override
    if cfg ~= 'auto' then return cfg end

    -- Auto-detection order: LXR → RSG → VORP → RedEM → QBR → QR → standalone
    if GetResourceState('lxr-core') == 'started' then return 'lxr-core' end
    if GetResourceState('rsg-core') == 'started' then return 'rsg-core' end
    if GetResourceState('vorp_core') == 'started' then return 'vorp_core' end
    if GetResourceState('redem_roleplay') == 'started' then return 'redem_roleplay' end
    if GetResourceState('qbr-core') == 'started' then return 'qbr-core' end
    if GetResourceState('qr-core') == 'started' then return 'qr-core' end
    return 'standalone'
end

local Bridge = {}

local function InitBridge()
    _framework = DetectFramework()
    print(string.format("^2[lxr-farming]^7 Framework detected: ^3%s^7", _framework))

    -- ── LXR-Core ─────────────────────────────────────────────────────────────
    if _framework == 'lxr-core' then
        function Bridge.GetPlayer(src)
            return exports['lxr-core']:GetPlayer(src)
        end
        function Bridge.AddItem(player, item, count, _slot)
            return player.Functions.AddItem(item, count)
        end
        function Bridge.RemoveItem(player, item, count, slot)
            return player.Functions.RemoveItem(item, count, slot)
        end
        function Bridge.RegisterUsableItem(name, cb)
            exports['lxr-core']:CreateUseableItem(name, cb)
        end

    -- ── RSG-Core ─────────────────────────────────────────────────────────────
    elseif _framework == 'rsg-core' then
        local RSGCore = exports['rsg-core']:GetCoreObject()
        function Bridge.GetPlayer(src)
            return RSGCore.Functions.GetPlayer(src)
        end
        function Bridge.AddItem(player, item, count, _slot)
            return player.Functions.AddItem(item, count)
        end
        function Bridge.RemoveItem(player, item, count, slot)
            return player.Functions.RemoveItem(item, count, slot)
        end
        function Bridge.RegisterUsableItem(name, cb)
            RSGCore.Functions.CreateUseableItem(name, cb)
        end

    -- ── VORP Core ─────────────────────────────────────────────────────────────
    elseif _framework == 'vorp_core' then
        local VORPcore = exports.vorp_core:GetCore()
        function Bridge.GetPlayer(src)
            local User = VORPcore.getUser(src)
            return User and User.getUsedCharacter and User.getUsedCharacter() or nil
        end
        function Bridge.AddItem(player, item, count, _slot)
            exports.vorp_inventory:addItem(player.source or -1, item, count)
            return true
        end
        function Bridge.RemoveItem(player, item, count, _slot)
            exports.vorp_inventory:subItem(player.source or -1, item, count)
            return true
        end
        function Bridge.RegisterUsableItem(name, cb)
            exports.vorp_inventory:registerUsableItem(name, cb)
        end

    -- ── Standalone (fallback) ─────────────────────────────────────────────────
    else
        function Bridge.GetPlayer(src) return {source = src} end
        function Bridge.AddItem(_player, _item, _count, _slot) return true end
        function Bridge.RemoveItem(_player, _item, _count, _slot) return true end
        function Bridge.RegisterUsableItem(_name, _cb) end
        if _framework ~= 'standalone' then
            print(string.format("^1[lxr-farming]^7 Unsupported framework '%s' — falling back to standalone.", _framework))
        end
    end
end

-- Initialise bridge after resource starts so all exports are available, then
-- register seed items immediately after so there is no timing gap.
local function RegisterSeedItems()
    for k, v in pairs(Config.FarmingCrops) do
        local hash = k
        Bridge.RegisterUsableItem('seed_'..v, function(source, item)
            local src  = source
            local data = {item.name, item.slot, hash}
            TriggerClientEvent('lxr-farming:client:PlaceSeed', src, data)
        end)
    end
end

local function OnBridgeReady()
    InitBridge()
    RegisterSeedItems()
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        OnBridgeReady()
    end
end)
OnBridgeReady() -- also run immediately for hot-restarts

local PlantObjects = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ EVENTS ███████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

RegisterNetEvent('lxr-farming:server:GetCrop', function(zone, index, hash)
    local src    = source
    local Player = Bridge.GetPlayer(src)
    if not Player then return end
    if not Bridge.AddItem(Player, Config.FarmingCrops[hash], math.random(4, 8), nil) then return end
    PlantObjects[zone][index] = false
    GlobalState['FarmingZone:'..zone] = PlantObjects[zone]
end)

RegisterNetEvent('lxr-farming:server:PlantSeed', function(data, zone)
    local src    = source
    local Player = Bridge.GetPlayer(src)
    if not Player then return end
    local name, slot, hash = table.unpack(data)
    if not Bridge.RemoveItem(Player, name, 1, slot) then return end
    local coords = GetEntityCoords(GetPlayerPed(src))
    if not PlantObjects[zone] then PlantObjects[zone] = {} end
    PlantObjects[zone][#PlantObjects[zone]+1] = {tick = 1, coords = vector3(coords.x, coords.y, coords.z - 1.95), hash = hash}
    GlobalState['FarmingZone:'..zone] = PlantObjects[zone]
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ THREADS ██████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

CreateThread(function()
    local timer = Config.Ticker * 60000
    while true do
        if next(PlantObjects) then
            for i=1, #PlantObjects do
                local change = false
                if PlantObjects[i] and next(PlantObjects[i]) then
                    for k=1, #PlantObjects[i] do
                        local current = PlantObjects[i]?[k]
                        if current and current.tick < 5 then
                            current.tick = current.tick + 1
                            local coords = current.coords
                            current.coords = vector3(coords.x, coords.y, coords.z + 0.25)
                            change = true
                        end
                    end
                    if change then
                        GlobalState['FarmingZone:'..i] = PlantObjects[i]
                    end
                end
            end
        end
        Wait(timer)
    end
end)
