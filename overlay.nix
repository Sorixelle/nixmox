final: prev:

{
  oomox = prev.callPackage ./packages/oomox {
    withPlugins = plugins: final.oomox.override { inherit plugins; };
  };

  oomoxFull = final.oomox.withPlugins (with final.oomoxPlugins; [
    image
    xresources
  ]);

  oomoxPlugins = import ./packages/oomox/plugins;
}
