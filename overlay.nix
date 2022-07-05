final: prev:

{
  oomox = prev.callPackage ./packages/default.nix {
    unwrapped = prev.callPackage ./packages/base.nix { };
    withPlugins = f: final.oomox.override { plugins = f final.oomoxPlugins; };
  };

  oomoxFull = final.oomox.withPlugins builtins.attrValues;

  oomoxPlugins = import ./packages/plugins { pkgs = final; };
}
