<img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/lxrcore-logo.png" alt="LXRCore" width="72" align="left" style="margin-right:12px">

# lxr-farming — Seed, water and time, for LXRCore

Break ground with a hoe, put a seed in, water it from a bucket, come back.
Plants live on the server and survive restarts; they grow through three
stages, wither if nobody comes for them, and stop in winter. Seeds and
produce are core catalog items — bought and sold on the same shelves as
everything else, no second price list.

![The plant card](docs/img/plant.png)

## What it does

* **Planting** — use a seed packet (`seed_corn`, `seed_potato`, `seed_carrot`,
  `seed_tomato`, `seed_tobacco`, `seed_sugar_beet`) standing in a field with a
  hoe in the satchel. Fields are `Config.Fields.list`; `anywhere = true`
  allows open ground outside the towns.
* **Growth** — `minutes` per stage; a dry stage takes `dryFactor` times as
  long. **Water** with a bucket once per stage. Winter (lxr-weather's
  `GlobalState.calendar.season`) halts growth unless `winterGrows`.
* **Harvest** — ripe plants yield `min..max` of the crop item to the owner
  (or anyone, with `anyoneHarvests`). Ripe and ignored for `witherMinutes`,
  the plant dies. **Pull up** — the owner, or the law with `lawPulls`.
* **The card** — a plant card on the LXR UI Kit for the nearest plant:
  crop, stage meter, watered or dry, time to the next stage.
* **Props** — one per stage in `Config.Crops[*].props`; a model that fails
  `IsModelValid` is skipped and the plant is still marked by its prompt.
* **Events** — `lxr:farming:planted`, `lxr:farming:harvested`,
  `lxr:farming:pulled`.

## Install

```cfg
ensure lxr-core
ensure lxr-interact
ensure lxr-weather    # optional: seasons
ensure lxr-farming
```

The table `lxr_farming` is created by the core migration runner.

## API

| Name | Side | Purpose |
|---|---|---|
| `Plants(citizenid?)` | server | every plant, or one player's |
| `Remove(id)` | server | pull a plant |
| `Plants()` | client | the plants this client knows |

## Licence

© 2026 iBoss21 / LXRCore — All Rights Reserved. See `LICENSE`.
