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
Config.Crops = {
    ['corn'] = {
        stages = {
            [1] = {time = 300, model = 'prop_crop_stage1'},
            [2] = {time = 600, model = 'prop_crop_stage2'},
            [3] = {time = 900, model = 'prop_crop_stage3'}
        },
        yield = 5,
        requiresWater = true
    },
    ['wheat'] = {
        stages = {
            [1] = {time = 400, model = 'prop_wheat_stage1'},
            [2] = {time = 800, model = 'prop_wheat_stage2'},
            [3] = {time = 1200, model = 'prop_wheat_stage3'}
        },
        yield = 3,
        requiresWater = false
    }
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

