--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FARMING — Offline tests: crops from the catalog, fields, growth, locale parity
     Usage (from the lxr-farming folder):  lua tests/run.lua [--mock out.js en|ka]
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local CORE = os.getenv('LXR_CORE_PATH') or '../lxr-core'
package.path = CORE .. '/?.lua;' .. package.path
local ok = pcall(function() require('tests.lib.fxshim') end)
if not ok then print('lxr-core shim not found at ' .. CORE) os.exit(2) end
local Shim = require('tests.lib.fxshim')
for _, f in ipairs({ 'shared/main.lua', 'shared/locale.lua', 'locales/en.lua', 'config.lua', 'shared/catalog.lua', 'shared/items.lua', 'shared/prices.lua' }) do Shim.load(CORE .. '/' .. f) end
Config = nil Locale = nil
Shim.load('shared/locale.lua') Shim.load('locales/en.lua') Shim.load('locales/ka.lua') Shim.load('config.lua') Shim.load('shared/rules.lua')
local F = LXRFarming

local passed, failed = 0, 0
local function test(name, fn) local okT, err = xpcall(fn, debug.traceback) if okT then passed = passed + 1 print('  ^ ok   ' .. name) else failed = failed + 1 print('  x FAIL ' .. name .. '\n' .. err) end end
local function eq(a, b, msg) if a ~= b then error((msg or 'eq') .. ': expected ' .. tostring(b) .. ' got ' .. tostring(a), 2) end end

print('lxr-farming offline tests')
test('every crop has a catalog seed and yield, and the tools exist', function()
    for id, c in pairs(Config.Crops) do
        assert(LXRShared.Items[c.seed], id .. ' seed ' .. c.seed)
        assert(LXRShared.Items[c.yield.item], id .. ' yield ' .. c.yield.item)
        assert(c.yield.min >= 1 and c.yield.max >= c.yield.min and c.minutes > 0 and #c.props == 3, id)
        assert(LXRShared.ItemValue(c.yield.item) * c.yield.min > LXRShared.ItemValue(c.seed), id .. ' must be worth planting')
        local cid, def = F.CropForSeed(c.seed) eq(cid, id) assert(def == c)
        assert(Locale.Bundles.en['crop.' .. id], 'crop label ' .. id)
    end
    assert(LXRShared.Items[Config.Tools.plant] and LXRShared.Items[Config.Tools.water])
    assert(F.CropForSeed('bread') == nil)
end)
test('fields: listed fields, towns, open ground', function()
    local f = Config.Fields.list[1]
    assert(F.FieldAt({ x = f.coords.x + 5, y = f.coords.y, z = f.coords.z }).id == f.id)
    assert(F.FieldAt({ x = 0, y = 0, z = 0 }) == nil, 'nowhere by default')
    Config.Fields.anywhere = true
    eq(F.FieldAt({ x = 0, y = 0, z = 0 }).id, 'open')
    local t = Config.Fields.towns[1]
    assert(F.FieldAt({ x = t.coords.x, y = t.coords.y, z = t.coords.z }) == nil, 'not in town')
    Config.Fields.anywhere = false
    assert(F.Room({ x = 0, y = 0, z = 0 }, { { x = 10, y = 0, z = 0 } }))
    assert(not F.Room({ x = 0, y = 0, z = 0 }, { { x = 1, y = 0, z = 0 } }))
end)
test('growth: watered stages are faster, winter halts, ripe withers', function()
    local p = { crop = 'corn', stage = 1, progress = 0, watered = false }
    local dry, wet = F.StageSeconds('corn', false), F.StageSeconds('corn', true)
    eq(dry, wet * Config.Growth.dryFactor)
    assert(not F.Advance(p, wet, 1000, 'summer'), 'dry plant is not done after a wet stage')
    p.watered = true
    assert(F.Advance(p, 0, 1000, 'summer'), 'watering counts the progress already made')
    eq(p.stage, 2) eq(p.watered, false)
    assert(not F.Advance(p, dry, 2000, 'winter'), 'winter')
    assert(F.Advance(p, dry, 3000, 'spring'), 'winter time did not count') eq(p.stage, 3) eq(p.ripe_at, 3000)
    eq(F.Left(p), 0)
    assert(not F.Withered(p, 3000 + Config.Growth.witherMinutes * 60))
    assert(F.Withered(p, 3001 + Config.Growth.witherMinutes * 60))
    assert(not F.Advance(p, 99999, 4000, 'summer'), 'ripe stays ripe')
end)
test('yield within range under an injected rng', function()
    local item, n = F.Yield('corn', function(k) return 1 end) eq(item, 'corn') eq(n, Config.Crops.corn.yield.min)
    local _, hi = F.Yield('corn', function(k) return k end) eq(hi, Config.Crops.corn.yield.max)
    assert(F.Prop('corn', 3) == Config.Crops.corn.props[3])
end)
test('locale parity', function()
    local en, ka = Locale.Bundles.en, Locale.Bundles.ka
    local missing = {}
    for k in pairs(en) do if ka[k] == nil then missing[#missing + 1] = k end end
    eq(#missing, 0, 'ka missing: ' .. table.concat(missing, ', '))
end)
print(('%d passed, %d failed'):format(passed, failed))
if arg and arg[1] == '--mock' and arg[2] then
    Config.Lang = arg[3] or 'en'
    local f = assert(io.open(arg[2], 'w'))
    f:write('window.__LXR_MOCK__ = ' .. json.encode({ action = 'show', payload = { id = 7, crop = 'tobacco', stage = 2, watered = true, left = 1237, mine = true }, lang = Config.Lang, locale = Lang.bundle(), brand = { name = 'The Land of Wolves', theme = 'night' } }) .. ';\n')
    f:close()
    print('mock written to ' .. arg[2])
end
os.exit(failed == 0 and 0 or 1)
