# nixmox

Utilities for creating GTK+ and icon themes with [Oomox/Themix project tools](https://github.com/themix-project/oomox)

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
  nixmox = builtins.fetchTarball { url = "https://github.com/Sorixelle/nixmox/archive/<commit_hash>.tar.gz" };
in ...
```

## Usage

All packages provided are defined on `packages.<system>`:

- `oomox` - The base oomox GUI package. It doesn't contain any plugins - see the Plugins section below for how to add some.
- `oomoxFull` - The oomox GUI + all known plugins. Useful if you just want access to everything without going through manual customization steps.
- `oomoxPlugins` - The set of all oomox plugins provided.

There's also a Nixpkgs overlay, defined at `overlay` that contains the same packages.

### Plugins

To add plugins to the built oomox derivation, you can use `oomox.withPlugins` like so:

``` nix
oomoxWithPlugins = oomox.withPlugins (with oomoxPlugins; [
  base64
  icons-suruplus
  theme-materia
])
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

## License

This project is licensed under the [MIT License](https://github.com/Sorixelle/nixmox/blob/master/LICENSE). Feel free to use this in your projects, dotfiles, anything you want.
