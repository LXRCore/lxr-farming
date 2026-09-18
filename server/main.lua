--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FARMING — Server: the plants live here
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local LXR = exports['lxr-core']:GetLXR()
local F = LXRFarming
local RES = GetCurrentResourceName()
local plants = {}     -- id → plant
local buckets = {}

local function limited(src)
    local b = buckets[src]
    local now = GetGameTimer()
    if not b or now - b.at > Config.Security.rateLimit.windowMs then b = { at = now, n = 0 } buckets[src] = b end
    b.n = b.n + 1
    return b.n > Config.Security.rateLimit.burst
end
local function player(src) return LXRCore.Functions.GetPlayer(src) end
local function near(src, p, d)
    local ped = GetPlayerPed(src)
    return ped ~= 0 and #(GetEntityCoords(ped) - vector3(p.x, p.y, p.z)) <= d
end
local function season() local cal = GlobalState.calendar return cal and cal.season or 'summer' end
local function isLaw(P)
    local def = LXRShared.Jobs[P.PlayerData.job.name]
    return def and (def.type == 'leo' or def.type == 'federal') and P.PlayerData.job.onduty
end
local function public(p) return { id = p.id, crop = p.crop, x = p.x, y = p.y, z = p.z, stage = p.stage, watered = p.watered, left = F.Left(p), owner = p.citizenid } end
local function save(p)
    LXRCore.DB.UpdateAsync('UPDATE lxr_farming SET stage = ?, progress = ?, watered = ?, ripe_at = ? WHERE id = ?', { p.stage, math.floor(p.progress or 0), p.watered and 1 or 0, p.ripe_at, p.id })
end
local function remove(id, why)
    local p = plants[id]
    if not p then return end
    plants[id] = nil
    LXRCore.DB.UpdateAsync('DELETE FROM lxr_farming WHERE id = ?', { id })
    TriggerClientEvent('lxr-farming:client:remove', -1, id, why)
end
local function mine(citizenid)
    local n = 0
    for _, p in pairs(plants) do if p.citizenid == citizenid then n = n + 1 end end
    return n
end
local function inField(fieldId)
    local n = 0
    for _, p in pairs(plants) do if p.field == fieldId then n = n + 1 end end
    return n
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 💾 STATE
-- ═══════════════════════════════════════════════════════════════════════════════
LXRCore.DB.RegisterMigration(RES, '0001_farming', [[
CREATE TABLE IF NOT EXISTS `lxr_farming` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `crop` VARCHAR(32) NOT NULL,
  `field` VARCHAR(32) NOT NULL,
  `x` FLOAT NOT NULL, `y` FLOAT NOT NULL, `z` FLOAT NOT NULL,
  `stage` TINYINT NOT NULL DEFAULT 1,
  `progress` INT NOT NULL DEFAULT 0,
  `watered` TINYINT(1) NOT NULL DEFAULT 0,
  `ripe_at` INT NULL,
  `planted_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`), KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]])

CreateThread(function()
    Wait(1000)
    local rows = LXRCore.DB.Query('SELECT id, citizenid, crop, field, x, y, z, stage, progress, watered, ripe_at FROM lxr_farming') or {}
    for _, r in ipairs(rows) do
        if Config.Crops[r.crop] then plants[r.id] = { id = r.id, citizenid = r.citizenid, crop = r.crop, field = r.field, x = r.x, y = r.y, z = r.z, stage = r.stage, progress = r.progress, watered = r.watered == 1, ripe_at = r.ripe_at } end
    end
    if Config.Debug.printBanner then print(('^1[lxr-farming]^7 v%s — %d crops, %d fields, %d plants in the ground'):format(GetResourceMetadata(RES, 'version', 0), (function() local n = 0 for _ in pairs(Config.Crops) do n = n + 1 end return n end)(), #Config.Fields.list, #rows)) end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🌱 PLANT / WATER / HARVEST / PULL
-- ═══════════════════════════════════════════════════════════════════════════════
for _, c in pairs(Config.Crops) do
    LXRCore.Items.RegisterUsable(c.seed, function(src, item) TriggerClientEvent('lxr-farming:client:plant', src, item.name) end)
end

LXR.RPC.Register('lxr-farming:plant', function(src, seed, x, y, z)
    if limited(src) then return false, 'rate' end
    local P = player(src)
    local crop = F.CropForSeed(seed)
    if not P or not crop or type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then return false, 'invalid' end
    local pos = { x = x, y = y, z = z }
    if not near(src, pos, Config.Security.maxDistance) then return false, 'too_far' end
    if not F.Grows(season()) then return false, 'winter' end
    local field = F.FieldAt(pos)
    if not field then return false, 'not_field' end
    if not F.Room(pos, plants) then return false, 'too_close' end
    if mine(P.PlayerData.citizenid) >= Config.Limits.perPlayer then return false, 'too_many' end
    if inField(field.id) >= Config.Limits.perField then return false, 'field_full' end
    if LXRCore.Inventory.GetItemCount(src, Config.Tools.plant) < 1 then return false, 'no_tool', LXRShared.Items[Config.Tools.plant].label end
    if not P.Functions.RemoveItem(seed, 1, nil, 'farming:plant') then return false, 'no_seed' end
    local id = LXRCore.DB.Insert('INSERT INTO lxr_farming (citizenid, crop, field, x, y, z) VALUES (?, ?, ?, ?, ?, ?)', { P.PlayerData.citizenid, crop, field.id, x, y, z })
    local p = { id = id, citizenid = P.PlayerData.citizenid, crop = crop, field = field.id, x = x, y = y, z = z, stage = 1, progress = 0, watered = false }
    plants[id] = p
    TriggerClientEvent('lxr-farming:client:plant', -1, public(p))
    LXRCore.Emit('lxr:farming:planted', nil, src, crop, id)
    if Config.Debug.log then LXRCore.Log.info('farming', ('planted %s at %s'):format(crop, field.id), { source = src }) end
    return true, id
end)

LXR.RPC.Register('lxr-farming:water', function(src, id)
    if limited(src) then return false, 'rate' end
    local P, p = player(src), plants[tonumber(id) or 0]
    if not P or not p then return false, 'invalid' end
    if not near(src, p, Config.Security.maxDistance) then return false, 'too_far' end
    if p.stage >= 3 then return false, 'ripe' end
    if p.watered then return false, 'wet' end
    if LXRCore.Inventory.GetItemCount(src, Config.Tools.water) < 1 then return false, 'no_tool', LXRShared.Items[Config.Tools.water].label end
    p.watered = true
    save(p)
    TriggerClientEvent('lxr-farming:client:update', -1, public(p))
    return true
end)

LXR.RPC.Register('lxr-farming:harvest', function(src, id)
    if limited(src) then return false, 'rate' end
    local P, p = player(src), plants[tonumber(id) or 0]
    if not P or not p then return false, 'invalid' end
    if not near(src, p, Config.Security.maxDistance) then return false, 'too_far' end
    if p.stage < 3 then return false, 'not_ripe' end
    if p.citizenid ~= P.PlayerData.citizenid and not Config.Limits.anyoneHarvests then return false, 'not_yours' end
    local item, amount = F.Yield(p.crop)
    if not LXRCore.Inventory.CanCarry(src, item, amount) then return false, 'too_heavy' end
    if not P.Functions.AddItem(item, amount, nil, nil, 'farming:harvest') then return false, 'too_heavy' end
    remove(p.id, 'harvest')
    LXRCore.Emit('lxr:farming:harvested', nil, src, p.crop, item, amount)
    return true, { item = item, label = LXRShared.Items[item].label, amount = amount }
end)

LXR.RPC.Register('lxr-farming:pull', function(src, id)
    if limited(src) then return false, 'rate' end
    local P, p = player(src), plants[tonumber(id) or 0]
    if not P or not p then return false, 'invalid' end
    if not near(src, p, Config.Security.maxDistance) then return false, 'too_far' end
    if p.citizenid ~= P.PlayerData.citizenid and not (Config.Limits.lawPulls and isLaw(P)) then return false, 'not_yours' end
    remove(p.id, 'pull')
    LXRCore.Emit('lxr:farming:pulled', nil, src, p.crop, p.citizenid)
    return true
end)

RegisterNetEvent('lxr-farming:server:ready', function()
    local src = source
    local list = {}
    for _, p in pairs(plants) do list[#list + 1] = public(p) end
    TriggerClientEvent('lxr-farming:client:sync', src, list)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- ⏳ GROWTH
-- ═══════════════════════════════════════════════════════════════════════════════
CreateThread(function()
    local last = os.time()
    while true do
        Wait(Config.Growth.tickSeconds * 1000)
        local now = os.time()
        local dt, s = now - last, season()
        last = now
        for id, p in pairs(plants) do
            if F.Withered(p, now) then remove(id, 'wither')
            elseif F.Advance(p, dt, now, s) then save(p) TriggerClientEvent('lxr-farming:client:update', -1, public(p))
            elseif p.stage < 3 and (p.progress or 0) % 600 < dt then save(p) end
        end
    end
end)

AddEventHandler('playerDropped', function() buckets[source] = nil end)
exports('Plants', function(citizenid) local out = {} for _, p in pairs(plants) do if not citizenid or p.citizenid == citizenid then out[#out + 1] = public(p) end end return out end)
exports('Remove', function(id) remove(tonumber(id), 'export') end)
