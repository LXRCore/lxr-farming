--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FARMING — Client: the plants you can see, and the work on them
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local LXR = exports['lxr-core']:GetLXR()
local F = LXRFarming
local N = Citizen.InvokeNative
local plants, props, busy, nearId = {}, {}, false, nil

local function toast(key, kind, vars) LXRCore.Notify(Lang:t(key, vars), kind or 'info') end
local function page(action, payload) SendNUIMessage({ action = action, payload = payload, brand = LXRCore.Brand, lang = Config.Lang, locale = Lang.bundle() }) end
local function work(ms)
    busy = true
    local ped = PlayerPedId()
    N(0x524B54361229154F, ped, joaat(Config.Work.scenario), ms, true, false, false, false)
    Wait(ms)
    ClearPedTasks(ped)
    busy = false
end
local function citizenid() local d = LXRCore.Functions.GetPlayerData() return d and d.citizenid end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🌱 PROPS + PROMPTS
-- ═══════════════════════════════════════════════════════════════════════════════
local function despawn(id)
    local e = props[id]
    if not e then return end
    exports['lxr-interact']:Remove('lxr-farming:' .. id)
    if e ~= true and DoesEntityExist(e) then DeleteEntity(e) end
    props[id] = nil
end

local function options(p)
    return {
        { label = Lang:t('ui.water'), key = 'J', canInteract = function() return p.stage < 3 and not p.watered and not busy end, onSelect = function()
            work(Config.Work.waterMs)
            local ok, err, extra = LXR.RPC.Server('lxr-farming:water', p.id)
            if not ok then return toast('error.' .. tostring(err), 'error', { label = extra }) end
            toast('info.watered', 'success')
        end },
        { label = Lang:t('ui.harvest'), key = 'J', canInteract = function() return p.stage >= 3 and not busy end, onSelect = function()
            work(Config.Work.harvestMs)
            local ok, res = LXR.RPC.Server('lxr-farming:harvest', p.id)
            if not ok then return toast('error.' .. tostring(res), 'error') end
            toast('info.harvested', 'success', { amount = res.amount, label = res.label })
        end },
        { label = Lang:t('ui.pull'), key = 'E', canInteract = function() return not busy and (p.owner == citizenid() or Config.Limits.lawPulls) end, onSelect = function()
            local ok, err = LXR.RPC.Server('lxr-farming:pull', p.id)
            if not ok then return toast('error.' .. tostring(err), 'error') end
            toast('info.pulled', 'info')
        end },
    }
end

local function spawn(p)
    despawn(p.id)
    local label = ('%s — %s'):format(Lang:t('crop.' .. p.crop), Lang:t('stage.' .. F.STAGES[p.stage]))
    local model = F.Prop(p.crop, p.stage)
    local hash = model and joaat(model)
    if hash and IsModelValid(hash) then
        RequestModel(hash)
        local t = GetGameTimer() + 3000
        while not HasModelLoaded(hash) and GetGameTimer() < t do Wait(10) end
        if HasModelLoaded(hash) then
            local e = CreateObject(hash, p.x, p.y, p.z, false, false, false)
            PlaceObjectOnGroundProperly(e)
            FreezeEntityPosition(e, true)
            SetModelAsNoLongerNeeded(hash)
            props[p.id] = e
            exports['lxr-interact']:AddEntity('lxr-farming:' .. p.id, e, { label = label, distance = Config.Security.promptDistance, options = options(p) })
            return
        end
    end
    props[p.id] = true
    exports['lxr-interact']:AddPoint('lxr-farming:' .. p.id, vector3(p.x, p.y, p.z), { label = label, distance = Config.Security.promptDistance, options = options(p) })
end

RegisterNetEvent('lxr-farming:client:sync', function(list) for id in pairs(props) do despawn(id) end plants = {} for _, p in ipairs(list) do plants[p.id] = p end end)
RegisterNetEvent('lxr-farming:client:plant', function(p) if type(p) == 'table' then plants[p.id] = p end end)
RegisterNetEvent('lxr-farming:client:update', function(p)
    local old = plants[p.id]
    plants[p.id] = p
    if props[p.id] and (not old or old.stage ~= p.stage) then spawn(p) end
    if nearId == p.id then page('show', p) end
end)
RegisterNetEvent('lxr-farming:client:remove', function(id, why)
    despawn(id) plants[id] = nil
    if nearId == id then nearId = nil page('hide') end
end)

-- planting: the seed was used (server → here), find the ground in front of me
RegisterNetEvent('lxr-farming:client:plant', function(seed)
    if type(seed) ~= 'string' or busy then return end
    local ped = PlayerPedId()
    if IsPedOnMount(ped) or IsPedInAnyVehicle(ped, false) then return toast('error.dismount', 'error') end
    local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0)
    local ok, z = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z + 1.0, false)
    if not ok then return toast('error.not_field', 'error') end
    local spot = { x = pos.x, y = pos.y, z = z }
    if not F.FieldAt(spot) then return toast('error.not_field', 'error') end
    if not F.Room(spot, plants) then return toast('error.too_close', 'error') end
    work(Config.Work.plantMs)
    local res, err, extra = LXR.RPC.Server('lxr-farming:plant', seed, spot.x, spot.y, spot.z)
    if not res then return toast('error.' .. tostring(err), 'error', { label = extra }) end
    toast('info.planted', 'success')
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🔁 RANGE LOOP: props within range, the card for the nearest plant
-- ═══════════════════════════════════════════════════════════════════════════════
CreateThread(function()
    while GetResourceState('lxr-interact') ~= 'started' do Wait(1000) end
    while true do
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            local best, bestD = nil, Config.Security.promptDistance + 1.0
            for id, p in pairs(plants) do
                local d = #(pos - vector3(p.x, p.y, p.z))
                if d <= Config.Security.propRange and not props[id] then spawn(p) elseif d > Config.Security.propRange + 20.0 and props[id] then despawn(id) end
                if d < bestD then best, bestD = id, d end
            end
            if best ~= nearId then nearId = best if best then page('show', plants[best]) else page('hide') end end
        end
        Wait(2000)
    end
end)

-- field blips
CreateThread(function()
    for _, f in ipairs(Config.Fields.list) do
        if f.blip then
            local b = N(0x554D9D53F696D002, 1664425300, f.coords.x, f.coords.y, f.coords.z)
            if b and b ~= 0 then N(0x74F74D3207ED525C, b, joaat('blip_ambient_farm'), true) N(0x9CB1A1623062F402, b, f.label) end
        end
    end
end)

RegisterNetEvent('lxr:client:loaded', function() Wait(1500) TriggerServerEvent('lxr-farming:server:ready') end)
RegisterNetEvent('lxr:client:unloaded', function() for id in pairs(props) do despawn(id) end plants = {} nearId = nil page('hide') end)
AddEventHandler('onResourceStop', function(res) if res == GetCurrentResourceName() then for id in pairs(props) do despawn(id) end end end)
CreateThread(function() Wait(2000) if LocalPlayer.state.isLoggedIn then TriggerServerEvent('lxr-farming:server:ready') end end)
exports('Plants', function() return plants end)
