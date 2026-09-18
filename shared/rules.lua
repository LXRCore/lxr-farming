--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FARMING — Shared rules: crops, fields, stages, yields
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

LXRFarming = LXRFarming or {}
local F = LXRFarming
F.STAGES = { 'seedling', 'growing', 'ripe' }

---Crop id for a seed item, or nil.
function F.CropForSeed(seed)
    for id, c in pairs(Config.Crops) do if c.seed == seed then return id, c end end
end

local function dist(a, b) return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2 + (a.z - b.z) ^ 2) end

---Which field a position is in (nil when none). With `anywhere`, any spot outside a town counts as the field 'open'.
function F.FieldAt(pos)
    for _, f in ipairs(Config.Fields.list) do if dist(pos, f.coords) <= f.radius then return f end end
    if Config.Fields.anywhere then
        for _, t in ipairs(Config.Fields.towns) do if dist(pos, t.coords) <= t.radius then return nil end end
        return { id = 'open', label = 'open ground' }
    end
    return nil
end

---Is there room here (spacing) among the given plants?
function F.Room(pos, plants)
    for _, p in pairs(plants) do if dist(pos, p) < Config.Limits.spacing then return false end end
    return true
end

---Seconds a stage takes for this plant (watered or dry).
function F.StageSeconds(crop, watered)
    return Config.Crops[crop].minutes * 60 * (watered and 1 or Config.Growth.dryFactor)
end

---Does anything grow this season?
function F.Grows(season)
    return season ~= 'winter' or Config.Growth.winterGrows
end

---Advance a plant by `dt` seconds; returns true when its stage changed. p.stage 1..3, p.progress seconds into the stage, p.watered bool, p.ripe_at.
function F.Advance(p, dt, now, season)
    if p.stage >= 3 then return false end
    if not F.Grows(season) then return false end
    p.progress = (p.progress or 0) + dt
    local need = F.StageSeconds(p.crop, p.watered)
    if p.progress < need then return false end
    p.stage, p.progress, p.watered = p.stage + 1, 0, false
    if p.stage == 3 then p.ripe_at = now end
    return true
end

---Seconds left in the current stage (0 when ripe).
function F.Left(p)
    if p.stage >= 3 then return 0 end
    return math.max(0, F.StageSeconds(p.crop, p.watered) - (p.progress or 0))
end

---Has a ripe plant died on the stalk?
function F.Withered(p, now)
    return p.stage >= 3 and p.ripe_at and now - p.ripe_at > Config.Growth.witherMinutes * 60
end

---What a harvest gives (injectable rng).
function F.Yield(crop, rnd)
    local y = Config.Crops[crop].yield
    return y.item, y.min + (rnd or math.random)(y.max - y.min + 1) - 1
end

function F.Prop(crop, stage)
    local c = Config.Crops[crop]
    return c and c.props and c.props[stage]
end
