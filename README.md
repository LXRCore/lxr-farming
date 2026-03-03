# 🐺 LXR Farming System — wolves.land

> **The Land of Wolves** | Georgian RP 🇬🇪 | Serious Hardcore Roleplay
>
> Developer: iBoss21 / The Lux Empire
> Website: [https://www.wolves.land](https://www.wolves.land)
> Discord: [https://discord.gg/CrKcWdfd3A](https://discord.gg/CrKcWdfd3A)
> Store: [https://theluxempire.tebex.io](https://theluxempire.tebex.io)

---

LXR-Farming is a production-grade, multi-framework farming system for RedM. Players can plant seeds, tend growing crops, and harvest items once the crops reach maturity — all within configurable farming zones. Designed for serious RedM roleplay servers and fully Tebex-escrow compliant.

## Features

- **Multi-Framework Support** — Works with LXR-Core (primary), RSG-Core (primary), VORP Core, RedEM:RP, QBR-Core, QR-Core, and Standalone via automatic runtime detection.
- **Crop Growth System** — Dynamic multi-stage growth system; crops advance one stage per tick until ready to harvest.
- **Interactive Farming** — Players plant seeds with a usable item and harvest with an in-world hold prompt, complete with animations.
- **Configurable Zones** — Add as many PolyZone farming areas as you need, each with optional map blips.
- **Localization Ready** — English and Georgian (`ge`) locale strings included; add more as needed.
- **Resource Name Guard** — Runtime check prevents the resource from running under an incorrect folder name (Tebex escrow compliance).
- **Optimized Performance** — Minimal overhead; state bag sync keeps all clients in sync without continuous polling.

## Framework Support

| Framework    | Status    |
|--------------|-----------|
| LXR-Core     | ✅ Primary |
| RSG-Core     | ✅ Primary |
| VORP Core    | ✅ Supported |
| RedEM:RP     | ⚡ Optional |
| QBR-Core     | ⚡ Optional |
| QR-Core      | ⚡ Optional |
| Standalone   | 🔄 Fallback |

Framework is detected automatically at startup. Override with `Config.Framework = 'lxr-core'` (or any key above) in `config.lua`.

## Installation

1. Clone or download the `lxr-farming` resource:

   ```bash
   git clone https://github.com/LXRCore/lxr-farming.git
   ```

2. Place the folder (named **exactly** `lxr-farming`) inside your server's `resources` directory.

3. Add to your `server.cfg`:

   ```bash
   ensure lxr-farming
   ```

4. Edit `config.lua` to customise zones, crops, tick rate, and framework settings.

5. Restart the server.

## Configuration

### Key settings in `config.lua`

| Option | Default | Description |
|--------|---------|-------------|
| `Config.Framework` | `'auto'` | Framework to use (`'auto'` detects at runtime) |
| `Config.Ticker` | `20` | Minutes between crop growth ticks |
| `Config.Debug` | `false` | Show zone outlines and debug prints |
| `Config.Lang` | `'en'` | Locale key for notifications |

### Adding a farming zone

```lua
Config.FarmingZones = {
    [1] = {
        blip   = 669307703,                              -- map blip hash (false to disable)
        coords = vector4(1701.36, -1460.74, 47.86, 110.0),
        dim    = vector2(50.0, 100.0)
    },
}
```

### Adding a crop

```lua
Config.FarmingCrops = {
    [`ginseng_p`] = 'american_ginseng',   -- prop hash = item name
}
```

The corresponding usable seed item must be named `seed_american_ginseng`.

## Requirements

- **RedM** server
- **PolyZone** (`@PolyZone` dependency for zone detection)
- One of the supported frameworks (or Standalone mode)

## Future Updates

- **Animal Husbandry** — Raise livestock and produce animal products.
- **Farming Tools** — Plows, watering cans, and other interactive tools.
- **Weather Impact** — Crop growth influenced by in-game weather systems.

## Support

- Open an issue or PR on [GitHub](https://github.com/LXRCore/lxr-farming)
- Join the community on [Discord](https://discord.gg/CrKcWdfd3A)

---

© 2026 iBoss21 / The Lux Empire | [wolves.land](https://www.wolves.land) | All Rights Reserved

