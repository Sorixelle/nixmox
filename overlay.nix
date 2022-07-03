final: prev:

{
  oomox = prev.callPackage ./packages/oomox {
    unwrapped = prev.callPackage ./packages/oomox/base.nix { };
    withPlugins = plugins: final.oomox.override { inherit plugins; };
  };

  oomoxFull = final.oomox.withPlugins (builtins.attrValues final.oomoxPlugins);

  oomoxPlugins = import ./packages/oomox/plugins { pkgs = final; };
}
