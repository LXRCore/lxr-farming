# LXR-Farming

LXR-Farming is a comprehensive farming system developed for the LXRCore framework. It allows players to engage in farming activities such as planting, growing, and harvesting crops, providing a fully immersive and interactive roleplay experience. This script is designed for RedM servers and offers high configurability, ease of use, and optimal performance.

## Features

- **Fully Configurable**: Customize every aspect of the farming process, from crop types, growth times, and harvest yields to job permissions and locations.
- **Crop Growth System**: Includes a dynamic crop growth system with real-time stages such as planting, growing, and ready-to-harvest.
- **Interactive Farming**: Players can interact with the environment to plant seeds, water crops, and harvest them once they are ready.
- **Job Integration**: Perfect for farming roles, allowing specific job roles (like farmers) to handle crop planting and harvesting, with support for job-based permissions.
- **Multi-Language Support**: Easily translate and localize text within the script to fit the language preferences of your server's player base.
- **Optimized Performance**: Developed with server performance in mind, ensuring minimal impact on your server's resources.
- **Custom Crop Types**: Easily add new crops and plants into the system with adjustable growth rates and environmental conditions.
  
## Installation

1. Clone or download the `lxr-farming` resource from the [GitHub repository](https://github.com/LXRCore/lxr-farming).
   
   ```bash
   git clone https://github.com/LXRCore/lxr-farming.git
   ```

2. Add the `lxr-farming` resource to your `server.cfg`:

   ```bash
   ensure lxr-farming
   ```

3. Edit the configuration file to customize the farming settings (`config.lua`).

4. Ensure you have the latest version of LXRCore installed and running on your RedM server.

5. Restart your server and enjoy your new immersive farming system.

## Configuration

The `config.lua` file allows you to customize various aspects of the farming system, including:

- **Crops**: Add or remove crop types, define their growth stages, and set their harvest yields.
- **Permissions**: Set job roles that are authorized to perform farming tasks.
- **Growth Timers**: Adjust the growth time for each crop type.
- **Watering Requirements**: Enable or disable watering mechanics, and define how frequently crops need watering.

Example Configuration:

```lua
Config = Config or {}

-- General Configuration
Config.Ticker = 20 -- Tick Every 20 Minutes
Config.Debug = false

-- Farming Zones Configuration
-- Blips List: https://github.com/femga/rdr3_discoveries/tree/3f8917d8b581736548387d3296aa6288b5168869/useful_info_from_rpfs/textures/blips
Config.FarmingZones = {
    [1] = {
        blip   = 669307703, -- Remove or set to false to disable
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

-- Crop Configuration
-- This section defines the prop that adds a prompt to pick the crop and the item to receive once picked
Config.FarmingCrops = {
    [`ginseng_p`]            = 'american_ginseng',
    [`alaskanginseng_p`]     = 'alaskan_ginseng',
    [`blackcurrant_p`]       = 'black_currant',
    [`s_inv_huckleberry01x`] = 'huckle_berry',
    [`s_inv_blackberry01x`]  = 'black_berry',
    [`s_inv_baybolete01bx`]  = 'bay_bolete',
    [`wildmint_p`]           = 'mint',
    [`s_indiantobacco01x`]   = 'tobacco',
    [`crp_cornstalks_bc_sim`] = 'corn',
    [`indtobacco_p`]         = 'coffee'
}

```

## Requirements

- **LXRCore**: This script requires the LXRCore framework to function correctly.
- **RedM**: Compatible with RedM servers for enhanced roleplay experiences.

## Future Updates

- **Animal Husbandry**: Upcoming features include raising livestock and producing animal products like wool and milk.
- **Farming Tools**: Additional farming tools such as plows and watering cans.
- **Weather Impact**: Integration with weather systems to influence crop growth.

## Support

For issues, suggestions, or contributions, please open an issue or a pull request on the [GitHub repository](https://github.com/LXRCore/lxr-farming).

Join our community on [Discord](https://discord.gg/5DGEv4kK7Q) for support and discussions related to LXRCore and LXR-Farming.

