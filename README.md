# nixmox

Nix utilities for creating GTK+ and icon themes with [Oomox/Themix project tools](https://github.com/themix-project/oomox)

## Getting started

This repo exposes a [Nix flake](https://nixos.wiki/wiki/Flakes). You can use it the same you you would any other flake, eg.

``` nix
{
  inputs = {
    nixmox.url = "github:Sorixelle/nixmox";
  };
}
```

If you're not using flakes, you can pull the `default.nix` file in the root of this repo in whichever way works best for you ([niv](https://github.com/nmattia/niv), `builtins.fetchTarball`, etc.):

``` nix
let
  nixmox = builtins.fetchTarball { url = "https://github.com/Sorixelle/nixmox/archive/<commit_hash>.tar.gz"; };
in ...
```

## Usage

All packages provided are defined on `packages.<system>`, or added to Nixpkgs if using the overlay:

- `oomox` - The base oomox GUI package. It doesn't contain any plugins - see the Plugins section below for how to add some.
- `oomoxFull` - The oomox GUI + all known plugins. Useful if you just want access to everything without going through manual customization steps.
- `oomoxPlugins` - The set of all oomox plugins provided.

There's also a Nixpkgs overlay, defined at `overlay` that contains the same packages.

### Plugins

To add plugins to the built oomox derivation, you can use `oomox.withPlugins` like so:

``` nix
{
  oomoxWithPlugins = oomox.withPlugins (ps: [
    ps.base64
    ps.icons-suruplus
    ps.theme-materia
  ]);
}
```

List of currently avaliable plugins:

- `base64`
- `export-xresources`
- `icons-archdroid`
- `icons-gnome-colors`
- `icons-numix`
- `icons-papirus`
- `icons-suruplus`
- `icons-suruplus-aspromauros`
- `import-image`
- `import-xresources`
- `theme-materia`
- `theme-oomox`

### Generate themes

Each icon and theme plugin also has a `generate` function, which can be used to create a derivation which will build a theme or icon pack from an oomox theme file.

Sample usage:

``` nix
{
  myTheme = oomoxPlugins.theme-oomox.generate {
    name = "my-theme";
    src = ./my-theme.theme;
  };
}
```

In this example, `myTheme` will be a package containing your theme, at `share/themes` (or `share/icons` for icon packs).

All plugins require the following parameters:

- `name`: The name of the theme,
- `src`: Path to an oomox theme file. You can get this file by saving a theme in the oomox GUI, then copying it from `~/.config/oomox/colors/<theme_name>`.

Some plugins accept additional parameters:

`theme-oomox`:

- `hidpi`: Whether to generate GTK+2 assets with 2x scaling.
- `gtkVariant`: Which variant of the GTK+3 theme to build. One of `all`, `gtk3`, or `gtk320`

## License

This project is licensed under the [MIT License](https://github.com/Sorixelle/nixmox/blob/master/LICENSE). Feel free to use this in your projects, dotfiles, anything you want.
