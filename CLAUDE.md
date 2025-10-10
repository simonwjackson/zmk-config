# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a ZMK (Zephyr Mechanical Keyboard) firmware configuration for a Corne (CRKBD) split keyboard using nice!nano v2 controllers. ZMK is a modern, wireless-first keyboard firmware built on the Zephyr RTOS.

## Architecture

- **Configuration Management**: Uses West (Zephyr's meta-tool) for dependency management
- **Build System**: Zephyr's CMake-based build system
- **Firmware Target**: nice_nano_v2 board with corne_left/corne_right shields
- **Build Automation**: GitHub Actions automatically builds firmware on push/PR

### Key Files

- `build.yaml`: Defines build matrix for GitHub Actions (board/shield combinations)
- `config/west.yml`: West manifest defining ZMK dependency and version (v0.3)
- `config/corne.keymap`: Main keymap definition with 3 layers (default, lower, raise)
- `config/corne.conf`: Configuration options (RGB underglow, OLED display disabled by default)
- `zephyr/module.yml`: Zephyr module configuration for board definitions

### Project Structure

```
config/           # ZMK configuration files
├── corne.keymap  # Keymap with 3 layers
├── corne.conf    # Feature configuration
└── west.yml      # Dependency manifest

boards/shields/   # Custom board/shield definitions (if any)
zephyr/          # Zephyr module configuration
build.yaml       # GitHub Actions build matrix
```

## Development Commands

### Building Firmware Locally

This project includes a complete Nix flake for local ZMK development. To build firmware:

```bash
# Enter development shell (automatic with direnv)
nix develop

# Or if not using direnv
direnv allow

# Initialize workspace (first time only, if not already done)
west init -l config/
west update

# Build left half
west build -p -s zmk/app -b nice_nano_v2 -- -DSHIELD=corne_left -DZMK_CONFIG="$PWD/config"

# Build right half
west build -p -s zmk/app -b nice_nano_v2 -- -DSHIELD=corne_right -DZMK_CONFIG="$PWD/config"
```

**Note**: The local build setup includes a patched kconfig.py that treats warnings as non-fatal, which is necessary for ZMK v0.3 builds.

### Alternative: GitHub Actions Build

Since this project also uses GitHub Actions for automated building:

```bash
# Simply push your changes and GitHub Actions will build firmware
git add config/corne.keymap
git commit -m "Update keymap"
git push
```

### Making Changes

1. Edit keymap in `config/corne.keymap`
2. Modify configuration in `config/corne.conf`
3. Update build matrix in `build.yaml` if adding new board/shield combinations
4. Commit and push - GitHub Actions will build firmware automatically

**Important**: Any changes to `config/corne.keymap` bindings must maintain column alignment for readability. ASCII art comments above each layer must also be updated to reflect any key mapping changes.

### Keymap Structure

The keymap uses ZMK's devicetree syntax with 3 layers:
- Layer 0 (default): QWERTY layout
- Layer 1 (lower): Numbers, Bluetooth controls, arrows
- Layer 2 (raise): Symbols and special characters

Layer switching uses momentary layer-toggle behavior (`&mo`) on thumb keys.

### Configuration Options

Common options in `corne.conf`:
- `CONFIG_ZMK_RGB_UNDERGLOW=y` - Enable RGB underglow
- `CONFIG_ZMK_DISPLAY=y` - Enable OLED display
- `CONFIG_ZMK_SLEEP=y` - Enable deep sleep mode

## Local Development Environment

### Flake Dependencies

The `flake.nix` includes all necessary dependencies:
- West (Zephyr meta-tool)
- ARM GCC embedded toolchain
- CMake and Ninja build tools
- Device tree compiler (dtc)
- Python packages: PyYAML, canopen, pyelftools, etc.

### Troubleshooting

**Kconfig Warnings**: The local build includes a patched `zephyr/scripts/kconfig/kconfig.py` that treats warnings as non-fatal. This is stored in the backup file `kconfig.py.backup`.

**Build Output**: Successful builds generate `build/zephyr/zmk.uf2` firmware files ready for flashing to nice!nano controllers.

**Clean Build**: To force a clean build, delete the `build` directory before running west build.

## Build Reproducibility

### Hermetic Build Status

This project is **partially hermetic** with the following guarantees:

**Hermetic aspects:**
- ✅ **Nix flake** (`flake.nix`, `flake.lock`) - pins exact versions of all build tools
- ✅ **West manifest** (`config/west.yml`) - pins ZMK to v0.3
- ✅ **GitHub Actions** - uses ZMK's official build workflow at v0.3 for maximum reproducibility

**Non-hermetic gaps:**
- ❌ **West dependencies** - `west update` fetches latest compatible versions within ZMK v0.3 constraints
- ❌ **Zephyr submodules** - ZMK pulls in Zephyr and modules which may have floating dependencies
- ❌ **Local environment variations** - Different systems may have subtle toolchain differences

### Recommended Build Approach

For maximum reproducibility:

1. **Use GitHub Actions** (most hermetic) - Simply push changes and download firmware from Actions artifacts
2. **Nix development shell** (good hermeticity) - Provides controlled local environment
3. **Manual setup** (least hermetic) - System-dependent toolchain installation

### Improving Hermeticity

To make builds more hermetic:

```bash
# Lock West dependencies after update
west update
# Commit the resolved dependency versions if needed

# Use pure Nix environment for maximum isolation
nix develop --pure
```

The `.gitignore` excludes `zephyr/`, `zmk/`, and `modules/` directories to prevent committing dependency artifacts while maintaining configuration tracking.
