{ symlinkJoin
, pkgs

, unwrapped
, withPlugins
, plugins ? [ ]
}:

let
  allPlugins = symlinkJoin {
    name = "oomox-plugins";
    paths = [ unwrapped ] ++ plugins;
  };

  basePkg = unwrapped.overrideAttrs (_: {
    passthru = {
      inherit withPlugins;
      buildPlugin = pkgs.callPackage ./plugins/build-plugin.nix { };
    };
  });
in
if builtins.length plugins == 0 then basePkg else
(basePkg.override {
  extraPythonDeps =
    let
      pluginsWithDeps = builtins.filter (p: p ? pythonDeps) plugins;
    in
    ps: builtins.concatMap (p: p.pythonDeps ps) pluginsWithDeps;
}).overrideAttrs (old: {
  name = "${old.pname}-${old.version}-with-plugins";

  preFixup = ''
    gappsWrapperArgs+=(
      --set OOMOX_SCRIPT_DIR "${allPlugins}/opt/oomox/oomox_gui"
    )
  '';

  passthru = {
    inherit allPlugins unwrapped;
  };
})
