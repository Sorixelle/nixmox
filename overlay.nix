final: prev:

{
  oomox = prev.callPackage ./packages/default.nix {
    unwrapped = prev.callPackage ./packages/base.nix { };
    withPlugins = plugins: final.oomox.override { inherit plugins; };
  };

  oomoxFull = final.oomox.withPlugins (builtins.attrValues final.oomoxPlugins);

  oomoxPlugins = import ./packages/plugins { pkgs = final; };
}
