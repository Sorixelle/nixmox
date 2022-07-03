final: prev:

{
  oomox = prev.callPackage ./packages/oomox {
    unwrapped = prev.callPackage ./packages/oomox/base.nix { };
    withPlugins = plugins: final.oomox.override { inherit plugins; };
  };

  oomoxFull = final.oomox.withPlugins (with final.oomoxPlugins; [
    import-image
  ]);

  oomoxPlugins = import ./packages/oomox/plugins { pkgs = final; };
}
