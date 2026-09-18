--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FARMING — Locale: English (canonical)
     Developer   : iBoss21 | Brand : LXRCore | https://www.lxrcore.com
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

Locale.Register('en', {
    error = { rate = 'Slow down.', invalid = 'Not now.', too_far = 'Get closer.', winter = 'Nothing grows in this cold.', not_field = 'This ground will not take a seed.', too_close = 'Too close to another plant.', too_many = 'You have enough in the ground already.', field_full = 'This field is planted out.', no_tool = 'You need a %{label}.', no_seed = 'You have no seed.', ripe = 'It is past watering.', wet = 'The ground is still wet.', not_ripe = 'Not ripe yet.', not_yours = 'Not your plant.', too_heavy = 'You cannot carry the harvest.', dismount = 'Get down first.' },
    info = { planted = 'Seed in the ground.', watered = 'Watered.', harvested = 'You pull %{amount} × %{label}.', pulled = 'Pulled up.' },
    crop = { corn = 'Corn', potato = 'Potatoes', carrot = 'Carrots', tomato = 'Tomatoes', tobacco = 'Tobacco', sugar_beet = 'Sugar beet' },
    stage = { seedling = 'Seedling', growing = 'Growing', ripe = 'Ripe' },
    ui = { water = 'Water', harvest = 'Harvest', pull = 'Pull up', watered = 'watered', dry = 'dry', ready = 'ready to harvest', left = '%{time} to next stage', not_yours = 'not yours' },
})
