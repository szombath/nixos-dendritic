# Wallpapers

Wallpapers used by [Stylix](https://github.com/danth/stylix) for system theming.

## Available Wallpapers

- `lighthouse.png`
- `nix.png`
...

## Usage

Wallpapers are referenced in host configurations:

```nix
wallpaper = ../../../wallpapers/nix.png;
```

Stylix uses the wallpaper to generate color schemes when using base16 schemes or can extract colors automatically.

## Adding Wallpapers

Simply add image files to this directory and reference them in your host configuration.
